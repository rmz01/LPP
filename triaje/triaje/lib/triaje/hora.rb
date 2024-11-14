# Clase Hora que representa una hora, con atributos para horas, minutos y segundos.
class Hora
  # Método de lectura para los atributos de la clase.
  # @return [Integer] horas, minutos o segundos.
  attr_reader :horas, :minutos, :segundos
  
  # Inicializa una nueva instancia de la clase 'Hora'.
  #
  # @param horas [Integer] La hora en formato de 24 horas (0 a 23) - variable local.
  # @param minutos [Integer] Los minutos (0 a 59) - variable local.
  # @param segundos [Integer] Los segundos (0 a 59) - variable local.
  def initialize(horas, minutos, segundos)
    # @horas, @minutos y @segundos son variables de instancia.
    @horas = horas
    @minutos = minutos
    @segundos = segundos
  end
  
  # Devuelve la representación en cadena de la hora en formato "hh:mm:ss".
  #
  # @return [String] La hora en formato `hh:mm:ss`.
  def to_s
    format("%02d:%02d:%02d", @horas, @minutos, @segundos)
  end
end