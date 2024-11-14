# frozen_string_literal: true

require "test_helper"

class HoraTest < Test::Unit::TestCase
  # PRUEBAS DE LA CLASE HORA
  # Verifica que la inicialización de la clase Hora funcione correctamente
  # Se comprueba que los atributos hora, minutos y segundos se inicialicen correctamente.
  def test_hora_initialize
    hora = Hora.new(10, 20, 30)
    assert_equal(10, hora.horas)
    assert_equal(20, hora.minutos)
    assert_equal(30, hora.segundos)
  end

  # Verifica que el método to_s de la clase Hora devuelve el formato correcto
  def test_hora_to_s
    hora = Hora.new(10, 20, 30)
    assert_equal("10:20:30", hora.to_s)
  end
end
