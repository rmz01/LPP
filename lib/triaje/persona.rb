# triaje/lib/triaje/persona.rb

require_relative "fecha"

# La clase Persona representa a una persona con atributos básicos.
class Persona
  include Comparable
  include Enumerable

  attr_reader :id, :sexo

  # Variable de clase para contar el número de instancias de Persona.
  @@numero_instancias = 0

  # Inicializa una nueva instancia de Persona.
  #
  # @param id [Integer] Número de identificación de la persona.
  # @param nombre [String] Nombre de la persona.
  # @param apellido [String] Apellido de la persona.
  # @param sexo [String] Sexo de la persona ("M" o "F").
  # @param fecha_nacimiento [Fecha] Fecha de nacimiento como instancia de la clase `Fecha`.
  def initialize(id, nombre, apellido, sexo, fecha_nacimiento)
    @id = id
    @nombre = nombre
    @apellido = apellido
    @sexo = sexo
    @fecha_nacimiento = fecha_nacimiento
    @@numero_instancias += 1
  end

  # Devuelve el número de instancias de Persona creadas.
  #
  # @return [Integer] El número de instancias de Persona.
  def self.numero_instancias
    @@numero_instancias
  end

  # Calcula la edad de la persona en base a la fecha actual.
  #
  # @return [Integer] La edad de la persona.
  def edad
    hoy = Date.today
    diferencia = Triaje.date_difference(Date.new(@fecha_nacimiento.year, @fecha_nacimiento.month, @fecha_nacimiento.day), hoy)
    diferencia[:years]
  end

  # Devuelve el nombre completo de la persona.
  #
  # @return [String] El nombre completo de la persona.
  def nombre_completo
    "#{@nombre} #{@apellido}"
  end

  # Devuelve una representación en cadena de la persona.
  #
  # @return [String] La representación en cadena de la persona.
  def to_s
    "ID: #{@id}, Nombre: #{@nombre} #{@apellido}, Apellido: #{@apellido}, Sexo: #{@sexo}, Fecha de Nacimiento: #{@fecha_nacimiento}"
  end

  # Compara si otra instancia de Persona es igual a esta instancia
  # basándose en el id, nombre completo, sexo y fecha de nacimiento.
  #
  # @param other [Persona] Otra instancia de Persona a comparar.
  # @return [Boolean] `true` si las instancias tienen los mismos atributos, de lo contrario `false`.
  def ==(other)
    return false unless other.is_a?(Persona)
    @id == other.id &&
    nombre_completo == other.nombre_completo &&
    @sexo == other.sexo &&
    @fecha_nacimiento == other.fecha_nacimiento
  end

  protected

  # Devuelve la fecha de nacimiento de la persona.
  #
  # @return [Fecha] La fecha de nacimiento de la persona.
  attr_reader :fecha_nacimiento

  private

  # Devuelve el nombre de la persona.
  #
  # @return [String] El nombre de la persona.
  attr_reader :nombre

  # Devuelve el apellido de la persona.
  #
  # @return [String] El apellido de la persona.
  attr_reader :apellido

  # Implementa el operador de comparación para que los objetos de esta clase sean comparables.
  # Para comparar dos objetos de la clase persona, se utilizara la edad
  # @param other [Persona] Otra instancia de `Persona` a comparar.
  # @return [Integer] -1, 0, 1 dependiendo de si la instancia es menor, igual o mayor que la otra.
  def <=>(other)
    return nil unless other.is_a?(Persona)
    edad <=> other.edad
  end

  # Implementa el método `each` de la clase `Enumerable`.
  # @return [Object] Los atributos de la persona.
  def each
    yield @id
    yield nombre_completo
    yield @sexo
    yield @fecha_nacimiento
  end
end