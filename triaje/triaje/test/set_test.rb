# frozen_string_literal: true

require "test_helper"

class SetTest < Test::Unit::TestCase
  # PRUEBAS DE LA CLASE SET
  # Verifica que la inicialización de la clase Set funcione correctamente
  # Se comprueba que los atributos nivel, color, categoria y tiempo_espera se inicialicen correctamente.
  def test_set_initialize
    set = Set.new(3, "Naranja", "Urgente", 30)
    assert_equal(3, set.nivel)
    assert_equal("Naranja", set.color)
    assert_equal("Urgente", set.categoria)
    assert_equal(30, set.tiempo_espera)
  end

  # Verifica que el método to_s de la clase Set devuelve el formato correcto
  def test_set_to_s
    set = Set.new(3, "Naranja", "Urgente", 30)
    assert_equal("Nivel: 3, Color: Naranja, Categoría: Urgente, Tiempo de espera: 30 minutos", set.to_s)
  end
end
