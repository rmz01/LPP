# frozen_string_literal: true

require "test_helper"

# Clase de prueba para verificar el funcionamiento de la gema Triaje.
# Se realizan pruebas sobre la clases 'Hora' 'Fecha' y 'Set' y el módulo 'Triaje'.
class TriajeTest < Test::Unit::TestCase
  # Verifica que la constante VERSION esté definida
  def test_version_exists
    assert ::Triaje.const_defined?(:VERSION)
  end

  # PRUEBAS DEL MÓDULO TRIAJE
  # Verifica que el método diferencia_en_fechas funcione correctamente
  # Se comprueba que la diferencia en años, meses y días entre dos fechas sea correcta.
  # Ejemplo 1 
  def test_diferencia_en_fechas
    fecha1 = Fecha.new(10, 5, 2021)
    fecha2 = Fecha.new(15, 8, 2023)
    diferencia = Triaje.diferencia_en_fechas(fecha1, fecha2)
    assert_equal({ anyos: 2, meses: 3, dias: 5 }, diferencia)
  end
  
  # Ejemplo 2
  def test_diferencia_en_fechas_2
    fecha1 = Fecha.new(10, 5, 2021)
    fecha2 = Fecha.new(10, 4, 2023)
    diferencia = Triaje.diferencia_en_fechas(fecha1, fecha2)
    assert_equal({ anyos: 1, meses: 11, dias: 0 }, diferencia)
  end

  # Verifica que el método diferencia_en_horas_minutos_segundos funcione correctamente
  # Se comprueba que la diferencia en horas, minutos y segundos entre dos horas sea correcta.
  # Ejemplo 1
  def test_diferencia_en_horas_minutos_segundos
    hora1 = Hora.new(10, 20, 30)
    hora2 = Hora.new(12, 36, 15)
    diferencia = Triaje.diferencia_en_horas_minutos_segundos(hora1, hora2)
    assert_equal({ horas: 2, minutos: 15, segundos: 45 }, diferencia)
  end

  # Ejemplo 2
  def test_diferencia_en_horas_minutos_segundos_2
    hora1 = Hora.new(10, 20, 30)
    hora2 = Hora.new(10, 20, 45)
    diferencia = Triaje.diferencia_en_horas_minutos_segundos(hora1, hora2)
    assert_equal({ horas: 0, minutos: 0, segundos: 15 }, diferencia)
  end

  # Verifica que el método tiempo_espera funcione correctamente
  # Se comprueba que el tiempo de espera de un nivel sea correcto.
  # Ejemplo 1
  def test_tiempo_espera
    hora_entrada = Hora.new(10, 0, 0)
    hora_actual = Hora.new(10, 6, 0)
    resultado = Triaje.obtener_prioridad(hora_entrada, hora_actual)
    assert_equal(2, resultado)
  end

  # Ejemplo 2
  def test_tiempo_espera_2
    hora_entrada = Hora.new(10, 0, 0)
    hora_actual = Hora.new(10, 16, 0)
    resultado = Triaje.obtener_prioridad(hora_entrada, hora_actual)
    assert_equal(3, resultado)
  end
end