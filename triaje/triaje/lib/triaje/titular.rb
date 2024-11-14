# Clase Titular que hereda de Medico
class Titular < Medico
  attr_reader :max_pacientes

  # Inicializa el médico titular con el número máximo de pacientes.
  def initialize(id, nombre, apellido, sexo, fecha_nacimiento, especialidad, pacientes_asignados = [], max_pacientes)
    super(id, nombre, apellido, sexo, fecha_nacimiento, especialidad, pacientes_asignados)
    @max_pacientes = max_pacientes
  end

  # Método que asigna un paciente al médico titular.
  # Lanza un error si el número de pacientes asignados supera el máximo permitido.
  def asignar_paciente(paciente)
    if @pacientes_asignados.size >= @max_pacientes
      raise ArgumentError, "El número máximo de pacientes ha sido alcanzado."
    else
      @pacientes_asignados << paciente
    end
  end

  # Método que verifica si la carga máxima de pacientes ha sido alcanzada.
  def carga_maxima_alcanzada?
    @pacientes_asignados.size >= @max_pacientes
  end

  # Método to_s para representar al médico titular como una cadena.
  def to_s
    super + ", Carga máxima de pacientes: #{@max_pacientes}, Carga alcanzada: #{carga_maxima_alcanzada? ? 'Sí' : 'No'}"
  end
end
