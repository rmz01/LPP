# test/paciente_test.rb

require "test_helper"

class PacienteTest < Test::Unit::TestCase
  def setup
    # Configuración inicial para las instancias de prueba de `Paciente`
    @prioridad = Triaje::NIVEL_II
    @diagnosticos = ["leve", "grave"]
    @paciente = Paciente.new(1, "Carlos", "López", "masculino", Fecha.new(20, 7, 1990), @prioridad, @diagnosticos)
    @otro_paciente = Paciente.new(2, "Ana", "Martínez", "femenino", Fecha.new(15, 5, 1985), Triaje::NIVEL_III, ["alta", "muy grave"])
  end

  # Verifica la herencia de `Persona` en `Paciente`
  def test_herencia_persona
    assert_equal(Paciente, @paciente.class)
    # Verifica que la superclase de `Paciente` es `Persona`
    assert_equal(Persona, @paciente.class.superclass)
  end

  # Verifica que `prioridad` y `diagnosticos` sean accesibles públicamente
  def test_acceso_publico_prioridad_diagnosticos
    assert_equal(@prioridad, @paciente.prioridad)
    assert_equal(["leve", "grave"], @paciente.diagnosticos)
  end

  # Verifica que `id`, `sexo` y `edad` sean accesibles públicamente desde `Persona`
  def test_acceso_publico_id_sexo_edad
    assert_equal(1, @paciente.id)
    assert_equal("masculino", @paciente.sexo)
    assert_equal(34, @paciente.edad)  # Ajusta el valor a la edad actual
  end

  # Verifica el último diagnóstico
  def test_ultimo_diagnostico
    assert_equal("grave", @paciente.ultimo_diagnostico)
    assert_equal("muy grave", @otro_paciente.ultimo_diagnostico)
  end

  # Verifica la igualdad entre dos objetos `Paciente` con los mismos atributos
  def test_igualdad_de_pacientes
    paciente_identico = Paciente.new(1, "Carlos", "López", "masculino", Fecha.new(20, 7, 1990), @prioridad, @diagnosticos)
    assert(@paciente == paciente_identico)
  end

  # Verifica que dos objetos `Paciente` con diferentes atributos no sean iguales
  def test_desigualdad_de_pacientes
    assert((@paciente == @otro_paciente) == false)
  end

  # Prueba de visibilidad privada en atributos de `Persona`
  def test_acceso_privado_nombre_apellido
    assert_raise(NoMethodError) { @paciente.nombre }
    assert_raise(NoMethodError) { @paciente.apellido }
  end

  # Prueba de visibilidad protegida en `fecha_nacimiento`
  def test_acceso_protegido_fecha_nacimiento
    assert_raise(NoMethodError) { @paciente.fecha_nacimiento }
  end

  # Prueba del método `to_s` para asegurar que devuelve la cadena en el formato esperado
  def test_to_s
    expected_string = "ID: 1, Nombre completo: Carlos López, Sexo: masculino, Nacimiento: 20/07/1990, Prioridad: Nivel: 2, Color: Rojo, Categoría: Emergencia, Tiempo de espera: 7 minutos, Diagnósticos: leve, grave"
    assert_equal(expected_string, @paciente.to_s)
  end

  # Prueba de asignación de diagnóstico
  def test_asignar_diagnostico
    @paciente.asignar_diagnostico("alta")
    assert_equal("alta", @paciente.ultimo_diagnostico)
    @paciente.asignar_diagnostico("muy grave")
    assert_equal("muy grave", @paciente.ultimo_diagnostico)
  end
end
