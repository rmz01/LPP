# frozen_string_literal: true

require_relative "fecha"

# Clase base `Persona` que encapsula las propiedades comunes de médicos y pacientes.
# Representa una persona con atributos de identificación, nombre completo, sexo y fecha de nacimiento.
class Persona
  @@contador_personas = 0
    
  # @return [String] El sexo de la persona
  attr_reader :id, :sexo
  
  # Inicializa una nueva instancia de `Persona`
  #
  # @param id [Integer] Número de identificación de la persona
  # @param nombre [String] Nombre de la persona
  # @param apellido [String] Apellido de la persona
  # @param sexo [String] Sexo de la persona ("M" o "F")
  # @param fecha_nacimiento [Fecha] Fecha de nacimiento como una instancia de la clase `Fecha`
  def initialize(id, nombre, apellido, sexo, fecha_nacimiento)
    @id = id
    @nombre = nombre
    @apellido = apellido
    @sexo = sexo
    @fecha_nacimiento = fecha_nacimiento
    @@contador_personas += 1
  end

  # Contador de personas creadas.
  #
  # @return [Integer] Número total de instancias de `Persona` creadas.
  def self.contador_personas
    @@contador_personas
  end

  # Calcula la edad de la persona en años en relación a la fecha actual.
  #
  # @return [Integer] La edad de la persona en años.
  def edad
    hoy = Fecha.new(Time.now.day, Time.now.month, Time.now.year)
    diferencia = Triaje.diferencia_en_fechas(@fecha_nacimiento, hoy)
    diferencia[:anyos]
  end

  # Devuelve el nombre completo de la persona, combinando el nombre y el apellido.
  #
  # @return [String] El nombre completo en formato "Nombre Apellido".
  def nombre_completo
    "#{@nombre} #{@apellido}"
  end

  # Compara si otra instancia de `Persona` es igual a esta instancia, basándose en
  # el id, nombre, apellido, sexo y fecha de nacimiento.
  #
  # @param other [Persona] Otra instancia de `Persona` a comparar.
  # @return [Boolean] `true` si las instancias tienen los mismos atributos, de lo contrario `false`.
  def ==(other)
    return false unless other.is_a?(Persona)
    @id == other.id &&
    nombre_completo == other.nombre_completo &&
    @sexo == other.sexo &&
    @fecha_nacimiento == other.fecha_nacimiento
  end

  # Convierte la instancia de `Persona` a una cadena de texto.
  #
  # @return [String] Una representación en cadena del objeto `Persona`.
  def to_s
    "ID: #{@id}, Nombre completo: #{nombre_completo}, Sexo: #{@sexo}, Nacimiento: #{@fecha_nacimiento}"
  end  

  protected

  # @return [Fecha] Fecha de nacimiento de la persona (visibilidad protegida).
  attr_reader :fecha_nacimiento

  private

  # Atributo privado para acceder al nombre de la persona
  # @return [String]
  attr_reader :nombre

  # Atributo privado para acceder al apellido de la persona
  # @return [String]
  attr_reader :apellido
end