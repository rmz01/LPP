# frozen_string_literal: true

require_relative "persona"
require_relative "paciente"

# Clase `Medico` que representa a un facultativo.
# Contiene la especialidad y un conjunto de pacientes asignados.
class Medico < Persona
  include Comparable
  include Enumerable

  # Especialidades válidas para el médico
  ESPECIALIDADES_VALIDAS = ["general", "geriatría", "pediatría"]

  # Acceso a la especialidad y pacientes asignados
  attr_reader :especialidad, :pacientes_asignados

  # Inicializa una nueva instancia de `Medico`.
  #
  # @param id [Integer] Número de identificación del médico.
  # @param nombre [String] Nombre del médico.
  # @param apellido [String] Apellido del médico.
  # @param sexo [String] Sexo del médico ("M" o "F").
  # @param fecha_nacimiento [Fecha] Fecha de nacimiento como instancia de la clase `Fecha`.
  # @param especialidad [String] Especialidad del médico.
  def initialize(id, nombre, apellido, sexo, fecha_nacimiento, especialidad, pacientes_asignados = [])
    super(id, nombre, apellido, sexo, fecha_nacimiento)

    # Verifica que la especialidad sea válida
    unless ESPECIALIDADES_VALIDAS.include?(especialidad)
      raise ArgumentError, "Especialidad inválida. Debe ser una de: #{ESPECIALIDADES_VALIDAS.join(', ')}"
    end

    @especialidad = especialidad
    @pacientes_asignados = pacientes_asignados
  end

  # Asigna un nuevo paciente al médico.
  #
  # @param paciente [Paciente] Instancia de `Paciente` a asignar.
  def asignar_paciente(paciente)
    @pacientes_asignados.push(paciente)
  end

  # Devuelve el número de pacientes asignados.
  #
  # @return [Integer] El número total de pacientes asignados.
  def numero_pacientes_asignados
    @pacientes_asignados.size
  end

  # Representación en cadena del objeto `Medico`.
  #
  # @return [String] Información del médico en el formato especificado.
  def to_s
    "#{nombre_completo} (Especialidad: #{@especialidad}), Número de pacientes: #{numero_pacientes_asignados}"
  end

  # Implementa el operador de comparación para que los objetos de esta clase sean comparables.
  # Para comparar dos objetos de la clase Medico, se utilizará el número de pacientes asignados.
  # @param other [Medico] Otra instancia de `Medico` a comparar.
  # @return [Integer] -1, 0, 1 dependiendo de si la instancia es menor, igual o mayor que la otra.
  def <=>(other)
    return nil unless other.is_a?(Medico)
    numero_pacientes_asignados <=> other.numero_pacientes_asignados
  end

  # Implementa el método `each` de la clase `Enumerable`.
  # @return [Object] Los atributos del médico.
  def each
    yield @id
    yield nombre_completo
    yield @sexo
    yield @fecha_nacimiento
    yield @especialidad
    yield @pacientes_asignados
  end
end