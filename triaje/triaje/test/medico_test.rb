require "test_helper"

class MedicoTest < Test::Unit::TestCase
  # Configura las variables de instancia antes de cada prueba.
  def setup
    # Crea una fecha de nacimiento para el médico y algunos pacientes.
    fecha_nacimiento = Fecha.new(10, 5, 1980)
    @paciente_1 = Paciente.new(1, "Juan", "Pérez", "masculino", fecha_nacimiento, Set.new(2, "Rojo", "Emergencia", 7), ["grave", "moderado"])
    @paciente_2 = Paciente.new(2, "Ana", "García", "femenino", fecha_nacimiento, Set.new(3, "Naranja", "Urgente", 30), ["leve", "moderado"])
    @paciente_3 = Paciente.new(3, "Pedro", "López", "masculino", fecha_nacimiento, Set.new(4, "Amarillo", "Urgente", 15), ["moderado", "grave"])
    @medico1 = Medico.new(1, "Carlos", "Gomez", "masculino", fecha_nacimiento, "general", [@paciente_1, @paciente_2])
    @medico2 = Medico.new(2, "Ana", "Martínez", "femenino", fecha_nacimiento, "pediatría", [@paciente_3])
  end

  # Verifica que el número de pacientes asignados sea correcto.
  def test_numero_de_pacientes
    assert_equal(2, @medico1.numero_pacientes_asignados)
    assert_equal(1, @medico2.numero_pacientes_asignados)
  end

  # Verifica que el método de asignación de pacientes funcione correctamente.
  def test_asignar_paciente
    @medico1.asignar_paciente(@paciente_1)
    assert_includes(@medico1.pacientes_asignados, @paciente_1)
  end

  # Verifica la conversión a cadena (to_s) para el médico.
  def test_to_s
    assert_equal("Carlos Gomez (Especialidad: general), Número de pacientes: 2", @medico1.to_s)
  end

  # Verifica la especialidad del médico.
  def test_especialidad
    assert_equal("general", @medico1.especialidad)
  end

  # Verifica la lista de pacientes asignados al médico.
  def test_pacientes_asignados
    assert_equal([@paciente_1, @paciente_2], @medico1.pacientes_asignados)
    assert_equal([@paciente_3], @medico2.pacientes_asignados)
  end

  # Verifica la igualdad entre dos objetos `Medico` con los mismos atributos.
  def test_igualdad_de_medicos
    medico_identico = Medico.new(1, "Carlos", "Gomez", "masculino", Fecha.new(10, 5, 1980), "general", [@paciente_1, @paciente_2])
    assert(@medico1 == medico_identico)
  end

    # Verifica que dos objetos `Medico` con diferentes atributos no sean iguales.
  def test_desigualdad_de_medicos
    assert((@medico1 == @medico2) == false)
  end

  # Verifica la herencia de Medico de Persona.
  def test_herencia
    assert_equal(@medico1.class, Medico)
    assert_equal(@medico1.class.superclass, Persona)
  end

  # Prueba de visibilidad privada en atributos de `Persona`
  def test_acceso_privado_nombre_apellido
    assert_raise(NoMethodError) { @medico1.nombre }
    assert_raise(NoMethodError) { @medico1.apellido }
  end

  # Prueba de visibilidad protegida en `fecha_nacimiento`
  def test_acceso_protegido_fecha_nacimiento
    assert_raise(NoMethodError) { @medico.fecha_nacimiento }
  end 
end
