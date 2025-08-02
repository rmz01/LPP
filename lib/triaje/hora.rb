# triaje/lib/triaje/hora.rb

# La clase Hora representa una hora específica del día.
class Hora
  include Comparable
  include Enumerable

  attr_reader :hora, :minuto, :segundo

  # Inicializa una nueva instancia de Hora.
  #
  # @param hora [Integer] La hora del día (0-23).
  # @param minuto [Integer] El minuto de la hora (0-59).
  # @param segundo [Integer] El segundo del minuto (0-59).
  def initialize(hora, minuto, segundo)
    @hora = hora
    @minuto = minuto
    @segundo = segundo
  end

  # Devuelve una representación en cadena de la hora.
  #
  # @return [String] La hora en formato "hora:minuto:segundo".
  def to_s
    "#{@hora}:#{@minuto}:#{@segundo}"
  end

  # Implementa el operador de comparación para que los objetos de esta clase sean comparables.
  # @param other [Hora] Otra instancia de `Hora` a comparar.
  # @return [Integer] -1, 0, 1 dependiendo de si la instancia es menor, igual o mayor que la otra.
  def <=>(other)
    return nil unless other.is_a?(Hora)
    [hora, minuto, segundo] <=> [other.hora, other.minuto, other.segundo]
  end

  # Implementa el método `each` de la clase `Enumerable`.
  # @return [Object] Los atributos de la hora.
  def each
    yield @hora
    yield @minuto
    yield @segundo
  end
end