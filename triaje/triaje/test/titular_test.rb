require "test_helper"

class TitularTest < Test::Unit::TestCase
  # Configura las variables de instancia antes de cada prueba.
  def setup
    fecha_nacimiento = Fecha.new(10, 5, 1980)

    # Crear pacientes
    @paciente_1 = Paciente.new(1, "Juan", "Pérez", "masculino", fecha_nacimiento, Set.new(2, "Rojo", "Emergencia", 7), "grave")
    @paciente_2 = Paciente.new(2, "Ana", "García", "femenino", fecha_nacimiento, Set.new(3, "Naranja", "Urgente", 30), "leve")

    # Crear un médico titular con un máximo de 2 pacientes
    @medico_titular = Titular.new(1, "Carlos", "Gomez", "masculino", fecha_nacimiento, "general", [@paciente_1], 2)
  end

  # Verifica que el médico titular no haya alcanzado la carga máxima de pacientes.
  def test_carga_maxima_no_alcanzada
    assert_equal(false, @medico_titular.carga_maxima_alcanzada?)
  end

  # Verifica que el médico titular haya alcanzado la carga máxima de pacientes.
  def test_carga_maxima_alcanzada
    @medico_titular.asignar_paciente(@paciente_2)
    assert_equal(true, @medico_titular.carga_maxima_alcanzada?)
  end

  # Verifica la conversión a cadena (to_s) para el médico titular.
  def test_to_s
    expected = "Carlos Gomez (Especialidad: general), Número de pacientes: 1, Carga máxima de pacientes: 2, Carga alcanzada: No"
    assert_equal(expected, @medico_titular.to_s)
  end

  # Verifica que se lanza un error si se asignan más pacientes de los permitidos.
  def test_asignar_mas_pacientes_de_los_permitidos
    @medico_titular.asignar_paciente(@paciente_2) # Asignar segundo paciente
    assert_raises(ArgumentError) do
      @medico_titular.asignar_paciente(Paciente.new(3, "Lucia", "Martínez", "femenino", Fecha.new(15, 3, 1995), Set.new(4, "Verde", "Urgente", 30), "leve"))
    end
  end

  # Verifica que la especialidad del médico titular sea válida.
  def test_especialidad_invalida
    assert_raises(ArgumentError) { Titular.new(1, "Carlos", "Gomez", "masculino", Fecha.new(10, 5, 1980), "cirugía", [], 2) }
  end

  # Verifica la herencia de Titular de Medico.
  def test_herencia
    assert_equal(@medico_titular.class, Titular)
    assert_equal(@medico_titular.class.superclass, Medico)
  end

  # Prueba de visibilidad privada en atributos de `Persona`
  def test_acceso_privado_nombre_apellido
    assert_raise(NoMethodError) { @medico_titular.nombre }
    assert_raise(NoMethodError) { @medico_titular.apellido }
  end

  # Prueba de visibilidad protegida en `fecha_nacimiento`
  def test_acceso_protegido_fecha_nacimiento
    assert_raise(NoMethodError) { @medico_titular.fecha_nacimiento }
  end 

  # Prueba visibilidad publica en `max_pacientes`
  def test_acceso_publico_max_pacientes
    assert_equal(2, @medico_titular.max_pacientes)
  end
end
