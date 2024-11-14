# test/persona_test.rb

require "test_helper"

class PersonaTest < Test::Unit::TestCase
  # Configura las variables de instancia `@persona` y `@otra_persona` antes de cada prueba
  def setup
    @persona = Persona.new(1, "Juan", "Pérez", "masculino", Fecha.new(10, 5, 1990))
    @otra_persona = Persona.new(2, "Ana", "García", "femenino", Fecha.new(15, 6, 1985))
  end

  # Verifica que `nombre_completo` devuelva el nombre y apellido correctamente concatenados
  def test_nombre_completo
    assert_equal("Juan Pérez", @persona.nombre_completo)
  end

  # Verifica que `edad` devuelva la edad correcta en base a la fecha actual (se ajusta la prueba en función de la fecha de nacimiento)
  def test_edad
    assert_equal(34, @persona.edad)
  end

  # Verifica que `to_s` devuelva la cadena en el formato esperado
  def test_to_s
    assert_equal("ID: 1, Nombre completo: Juan Pérez, Sexo: masculino, Nacimiento: 10/05/1990", @persona.to_s)
  end

  # Verifica que dos objetos `Persona` con los mismos atributos sean iguales
  def test_igualdad_de_personas
    persona_identica = Persona.new(1, "Juan", "Pérez", "masculino", Fecha.new(10, 5, 1990))
    assert(@persona == persona_identica)
  end

  # Verifica que dos objetos `Persona` con diferentes atributos no sean iguales
  def test_desigualdad_de_personas
    assert((@persona == @otra_persona) == false)
  end
  
  # Prueba de visibilidad privada: comprueba que el acceso directo a `nombre` y `apellido` provoque un error
  def test_acceso_privado_nombre_apellido
    assert_raise(NoMethodError) { @persona.nombre }
    assert_raise(NoMethodError) { @persona.apellido }
  end

  # Prueba de visibilidad protegida: comprueba que el acceso directo a `fecha_nacimiento` desde una instancia externa provoque un error
  def test_acceso_protegido_fecha_nacimiento
    assert_raise(NoMethodError) { @persona.fecha_nacimiento }
  end

  # Verifica que `id`, `sexo` y `edad` sean accesibles públicamente
  def test_acceso_publico
    assert_equal(1, @persona.id)
    assert_equal("masculino", @persona.sexo)
    assert_equal(34, @persona.edad)  # Este valor debe ajustarse a la fecha actual
  end
end
