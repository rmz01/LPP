# frozen_string_literal: true

require_relative "persona"

# Clase `Paciente` que hereda de `Persona`
# Representa un paciente con atributos adicionales como la prioridad de triaje y un conjunto de diagnósticos.
class Paciente < Persona
  include Comparable
  include Enumerable

  # Atributos específicos de `Paciente`
  attr_reader :prioridad, :diagnosticos

  # Inicializa una nueva instancia de `Paciente`, heredando de `Persona` y añadiendo atributos específicos de paciente.
  #
  # @param id [Integer] Número de identificación del paciente
  # @param nombre [String] Nombre del paciente
  # @param apellido [String] Apellido del paciente
  # @param sexo [String] Sexo del paciente ("M" o "F")
  # @param fecha_nacimiento [Fecha] Fecha de nacimiento del paciente
  # @param prioridad [Integer] Prioridad del paciente según el sistema de triaje español (1, 2, 3, etc.)
  def initialize(id, nombre, apellido, sexo, fecha_nacimiento, prioridad, diagnosticos = [])
    super(id, nombre, apellido, sexo, fecha_nacimiento)  # Llama al constructor de la clase padre (`Persona`)
    @prioridad = prioridad
    @diagnosticos = diagnosticos  # Inicia un array vacío para almacenar los diagnósticos
  end

  # Método para asignar un diagnóstico al paciente
  #
  # @param diagnostico [String] Diagnóstico a asignar ("alta", "leve", "grave", "muy grave")
  def asignar_diagnostico(diagnostico)
    valid_diagnosticos = ["alta", "leve", "grave", "muy grave"]
    if valid_diagnosticos.include?(diagnostico)
      @diagnosticos.push(diagnostico)
    else
      raise ArgumentError, "Diagnóstico no válido. Los diagnósticos permitidos son: alta, leve, grave, muy grave."
    end
  end

  # Método que devuelve el último diagnóstico asignado al paciente
  #
  # @return [String] Último diagnóstico asignado
  def ultimo_diagnostico
    @diagnosticos.last
  end

  # Método de conversión a cadena que devuelve los detalles del paciente
  #
  # @return [String] Representación en cadena del paciente, incluyendo prioridad y diagnósticos
  def to_s
    diagnosticos_str = @diagnosticos.empty? ? "No tiene diagnósticos asignados." : @diagnosticos.join(", ")
    "ID: #{@id}, Nombre completo: #{nombre_completo}, Sexo: #{@sexo}, Nacimiento: #{@fecha_nacimiento}, Prioridad: #{@prioridad}, Diagnósticos: #{diagnosticos_str}"
  end

  # Implementa el operador de comparación para que los objetos de esta clase sean comparables.
  # Para comparar dos objetos de la clase Paciente, se utilizará su prioridad.
  # @param other [Paciente] Otra instancia de `Paciente` a comparar.
  # @return [Integer] -1, 0, 1 dependiendo de si la instancia es menor, igual o mayor que la otra.
  def <=>(other)
    return nil unless other.is_a?(Paciente)
    prioridad <=> other.prioridad
  end

  # Implementa el método `each` de la clase `Enumerable`.
  # @return [Object] Los atributos del paciente.
  def each
    yield @id
    yield nombre_completo
    yield @sexo
    yield @fecha_nacimiento
    yield @prioridad
    yield @diagnosticos
  end
end