# triaje/lib/triaje/fecha.rb

# La clase Fecha representa una fecha específica.
class Fecha
  include Comparable
  include Enumerable

  attr_reader :dia, :mes, :anio

  def initialize(dia, mes, anio)
    @dia = dia
    @mes = mes
    @anio = anio
  end

  def year
    @anio
  end

  def month
    @mes
  end

  def day
    @dia
  end

  # Devuelve una representación en cadena de la fecha.
  #
  # @return [String] La fecha en formato "dia/mes/anio".
  def to_s
    "#{@dia}/#{@mes}/#{@anio}"
  end

  # Compara si otra instancia de `Fecha` es igual a esta instancia
  # basándose en el día, mes y año.
  # @param other [Fecha] Otra instancia de `Fecha` a comparar.
  # @return [Boolean] `true` si las instancias tienen los mismos atributos, de lo contrario `false`.
  def ==(other)
    return false unless other.is_a?(Fecha)
    @dia == other.dia &&
    @mes == other.mes &&
    @anio == other.anio
  end

  # Implementa el operador de comparación para que los objetos de esta clase sean comparables.
  # @param other [Fecha] Otra instancia de `Fecha` a comparar.
  # @return [Integer] -1, 0, 1 dependiendo de si la instancia es menor, igual o mayor que la otra.
  def <=>(other)
    return nil unless other.is_a?(Fecha)
    [anio, mes, dia] <=> [other.anio, other.mes, other.dia]
  end

  # Implementa el método `each` para que la clase sea enumerable.
  # @return [Object] Los atributos de la fecha.
  def each
    yield @dia
    yield @mes
    yield @anio
  end
end