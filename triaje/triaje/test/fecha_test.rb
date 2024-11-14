# frozen_string_literal: true

require "test_helper"

class FechaTest < Test::Unit::TestCase
  # PRUEBAS DE LA CLASE FECHA
  # Verifica que la inicialización de la clase Fecha funcione correctamente
  # Se comprueba que los atributos dia, mes y anyo se inicialicen correctamente.
  def test_fecha_initialize
    fecha = Fecha.new(10, 5, 2021)
    assert_equal(10, fecha.dia)
    assert_equal(5, fecha.mes)
    assert_equal(2021, fecha.anyo)
  end

  # Verifica que el método to_s de la clase Fecha devuelve el formato correcto
  def test_fecha_to_s
    fecha = Fecha.new(10, 5, 2021)
    assert_equal("10/05/2021", fecha.to_s)
  end
end
