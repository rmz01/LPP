class Titular < Medico
  include Enumerable

  attr_reader :max_pacientes

  # Inicializa el médico titular con el número máximo de pacientes.
  #
  # @param id [Integer] Número de identificación del médico.
  # @param nombre [String] Nombre del médico.
  # @param apellido [String] Apellido del médico.
  # @param sexo [String] Sexo del médico ("M" o "F").
  # @param fecha_nacimiento [Fecha] Fecha de nacimiento como instancia de la clase `Fecha`.
  # @param especialidad [String] Especialidad del médico.
  # @param pacientes_asignados [Array<Paciente>] Lista de pacientes asignados al médico.
  # @param max_pacientes [Integer] Número máximo de pacientes que el médico puede atender.
  def initialize(id, nombre, apellido, sexo, fecha_nacimiento, especialidad, pacientes_asignados = [], max_pacientes)
    super(id, nombre, apellido, sexo, fecha_nacimiento, especialidad, pacientes_asignados)
    @max_pacientes = max_pacientes
  end

  # Método que asigna un paciente al médico titular.
  # Lanza un error si el número de pacientes asignados supera el máximo permitido.
  #
  # @param paciente [Paciente] Instancia de `Paciente` a asignar.
  def asignar_paciente(paciente)
    if @pacientes_asignados.size >= @max_pacientes
      raise ArgumentError, "El número máximo de pacientes ha sido alcanzado."
    else
      @pacientes_asignados << paciente
    end
  end

  # Método que verifica si la carga máxima de pacientes ha sido alcanzada.
  #
  # @return [Boolean] `true` si la carga máxima ha sido alcanzada, `false` en caso contrario.
  def carga_maxima_alcanzada?
    @pacientes_asignados.size >= @max_pacientes
  end

  # Método to_s para representar al médico titular como una cadena.
  #
  # @return [String] Información del médico titular en el formato especificado.
  def to_s
    super + ", Carga máxima de pacientes: #{@max_pacientes}, Carga alcanzada: #{carga_maxima_alcanzada? ? 'Sí' : 'No'}"
  end

  # Implementa el método `each` de la clase `Enumerable`.
  # @return [Object] Los atributos del médico titular.
  def each
    yield @id
    yield nombre_completo
    yield @sexo
    yield @fecha_nacimiento
    yield @especialidad
    yield @max_pacientes
  end
end