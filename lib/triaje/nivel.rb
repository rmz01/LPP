# triaje/lib/triaje/nivel.rb

# La clase Nivel representa un conjunto de atributos relacionados con un nivel de triaje.
class Nivel
  include Comparable
  include Enumerable

  attr_reader :nivel, :color, :categoria, :tiempo

  # Inicializa una nueva instancia de Nivel.
  #
  # @param nivel [Integer] El nivel de triaje.
  # @param color [String] El color asociado al nivel de triaje.
  # @param categoria [String] La categoría del nivel de triaje.
  # @param tiempo [Integer] El tiempo de atención asociado al nivel de triaje en minutos.
  def initialize(nivel, color, categoria, tiempo)
    @nivel = nivel
    @color = color
    @categoria = categoria
    @tiempo = tiempo
  end

  # Devuelve una representación en cadena del conjunto de atributos.
  #
  # @return [String] Los atributos del conjunto en formato "Nivel: nivel, Color: color, Categoría: categoria, Tiempo: tiempo minutos".
  def to_s
    "Nivel: #{@nivel}, Color: #{@color}, Categoría: #{@categoria}, Tiempo: #{@tiempo} minutos"
  end

  # Implementa el operador de comparación para que los objetos de esta clase sean comparables según el atributo tiempo.
  # @param other [Nivel] Otra instancia de `Nivel` a comparar.
  # @return [Integer] -1, 0, 1 dependiendo de si la instancia es menor, igual o mayor que la otra.
  def <=>(other)
    return nil unless other.is_a?(Nivel)
    tiempo <=> other.tiempo
  end

  # Implementa el método `each` de la clase `Enumerable`.
  # @return [Object] Los atributos del nivel.
  def each
    yield @nivel
    yield @color
    yield @categoria
    yield @tiempo
  end
end