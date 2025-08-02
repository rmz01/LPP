require_relative "medico"
require_relative "fecha"
require_relative "hora"
require_relative "paciente"

# Clase ServicioSalud que representa un conjunto de servicios de salud.
class ServicioSalud
    include Comparable

    # Métodos de acceso a las variables de instancia.
    # @return [Integer] El identificador del servicio de salud.
    # @return [String] La descripción del servicio de salud.
    # @return [Hora] La hora de apertura del servicio de salud.
    # @return [Hora] La hora de cierre del servicio de salud.
    # @return [Array] Los días festivos del servicio de salud.
    # @return [Array] Los médicos asignados al servicio de salud.
    # @return [Array] Las camas del servicio de salud.
    attr_reader :id, :descripcion, :horario_apertura, :horario_cierre, :festivos, :medicos, :camas

    # Inicialización de la clase ServicioSalud.
    # @param id [Integer] El identificador del servicio de salud.
    # @param descripcion [String] La descripción del servicio de salud.
    # @param horario_apertura [Hora] La hora de apertura del servicio de salud.
    # @param horario_cierre [Hora] La hora de cierre del servicio de salud.
    # @param festivos [Array] Los días
    # @param medicos [Array] Los médicos asignados al servicio de salud.
    # @param camas [Array] Las camas del servicio de salud.
    def initialize(id, descripcion, horario_apertura, horario_cierre, festivos = [], medicos = [], camas = [])
        @id = id
        @descripcion = descripcion
        @horario_apertura = horario_apertura
        @horario_cierre = horario_cierre
        @festivos = festivos
        @medicos = medicos
        @camas = camas.map do
            {
              ocupada: false,
              paciente: nil,
              hora_entrada: nil,
              hora_salida: nil,
              fecha_entrada: nil,
              fecha_salida: nil
            }
        end
    end

    # Método para asignar un paciente a una cama.
    # @param paciente [Paciente] El paciente a asignar a la cama.
    def asignar_paciente_cama(paciente)
        cama_libre = @camas.find { |cama| !cama[:ocupada] }
        if cama_libre
            cama_libre[:ocupada] = true
            cama_libre[:paciente] = paciente
            cama_libre[:fecha_ingreso] = Fecha.new(1, 1, 2023) # Asignar fecha de ingreso
            cama_libre[:hora_ingreso] = Hora.new(10, 0, 0) # Asignar hora de ingreso
        else
            raise "No hay camas disponibles"
        end
    end

    # Método para determinar el número de camas libres.
    # @return [Integer] El número de camas libres.
    def camas_libres
        @camas.count { |cama| !cama[:ocupada] }
    end

    # Método para asignar un médico a un paciente.
    # @param medico [Medico] El médico a asignar al paciente.
    # @param paciente [Paciente] El paciente al que se le asignará el médico.
    def asignar_medico_paciente(medico, paciente)
        cama_ocupada = @camas.find { |cama| cama[:paciente] == paciente }
        if cama_ocupada
            cama_ocupada[:medico] = medico
            medico.asignar_paciente(paciente)
        else
            raise "El paciente no se encuentra en ninguna cama"
        end
    end

    # Método para determinar el número de pacientes asignados a un médico.
    # @param medico [Medico] El médico al que se le asignarán los pacientes.
    def numero_pacientes(medico)
        @camas.count { |cama| cama[:medico] == medico }
    end

    # Método para determinar la duración de la ocupación de una cama por un paciente.
    # @param fecha_ingreso [Fecha] La fecha de ingreso del paciente.
    # @param hora_ingreso [Hora] La hora de ingreso del paciente.
    # @param fecha_alta [Fecha] La fecha de alta del paciente.
    # @param hora_alta [Hora] La hora de alta del paciente.
    # @return [Integer] La duración total de la ocupación en minutos.
    def duracion_ocupacion(fecha_ingreso, hora_ingreso, fecha_alta, hora_alta)
        return { dias: 0, horas: 0, minutos: 0 } if fecha_ingreso.nil? || hora_ingreso.nil? || fecha_alta.nil? || hora_alta.nil?

        dias = (fecha_alta.anio - fecha_ingreso.anio) * 365 + (fecha_alta.mes - fecha_ingreso.mes) * 30 + (fecha_alta.dia - fecha_ingreso.dia)
        horas = hora_alta.hora - hora_ingreso.hora
        minutos = hora_alta.minuto - hora_ingreso.minuto
        { dias: dias, horas: horas, minutos: minutos }
    end

    # Método para determinar la duración media de la ocupación de las camas.
    # @return [Hash] La duración media de la ocupación.
    def duracion_media_ocupacion
        ocupadas = @camas.select { |cama| cama[:fecha_alta] && cama[:hora_alta] }
        return { dias: 0, horas: 0, minutos: 0 } if ocupadas.empty?
    
        total_duracion = ocupadas.map do |cama|
            duracion_ocupacion(cama[:fecha_ingreso], cama[:hora_ingreso], cama[:fecha_alta], cama[:hora_alta])
        end
    
        total_dias = total_duracion.sum { |duracion| duracion[:dias] }
        total_horas = total_duracion.sum { |duracion| duracion[:horas] }
        total_minutos = total_duracion.sum { |duracion| duracion[:minutos] }
    
        # Convertir minutos a horas y ajustar
        total_horas += total_minutos / 60
        total_minutos %= 60
    
        num_ocupadas = ocupadas.length
        media_dias = total_dias / num_ocupadas
        media_horas = total_horas / num_ocupadas
        media_minutos = total_minutos / num_ocupadas
    
        { dias: media_dias, horas: media_horas, minutos: media_minutos }
    end

    # Método to_s para mostrar la información completa del servicio de salud.
    # @return [String] Información del servicio de salud.
    def to_s
        "Id: #{@id}, Servicio de Salud: #{@descripcion}, Horario de apertura: #{@horario_apertura.to_s}, Horario de cierre: #{@horario_cierre.to_s}, Festivos: #{@festivos.map(&:to_s).join(', ')}, Número de médicos: #{@medicos.length}, Número de camas: #{@camas.length}"
    end

    # Compara 2 servicio de salud según el número de médicos asignados.
    # @param other [ServicioSalud] Otra instancia de `ServicioSalud` a comparar.
    def <=>(other)
        return nil unless other.is_a?(ServicioSalud)
        @medicos.length <=> other.medicos.length
    end

    # Método para calcular el tiempo medio de ocupación de las camas
    def tiempo_medio_ocupacion
        ocupadas = @camas.select { |cama| cama[:fecha_alta] && cama[:hora_alta] }
        return 0 if ocupadas.empty?
    
        total_minutos = ocupadas.collect do |cama|
            duracion = duracion_ocupacion(cama[:fecha_ingreso], cama[:hora_ingreso], cama[:fecha_alta], cama[:hora_alta])
            (duracion[:dias] * 24 * 60) + (duracion[:horas] * 60) + duracion[:minutos]
        end.sum
    
        total_minutos / ocupadas.length
    end

    # Método para calcular el índice de capacidad de respuesta
    def indice_capacidad_respuesta
        tiempo_medio = tiempo_medio_ocupacion
        ratio_medicos = ratio_facultativos_paciente
        case
            when tiempo_medio >= 30 && ratio_medicos.between?(0.2, 0.333)
                1
            when tiempo_medio >= 30 && ratio_medicos == 0.5
                1
            when tiempo_medio >= 30 && ratio_medicos == 1
                2
            when tiempo_medio.between?(15, 30) && ratio_medicos == 0.5
                2  
            when tiempo_medio.between?(15, 30) && ratio_medicos == 1
                2
            when tiempo_medio.between?(15, 30) && ratio_medicos.between?(0.2, 0.333)
                1
            when tiempo_medio <= 15 && ratio_medicos == 1
                3
            when tiempo_medio <= 15 && ratio_medicos == 0.5
                2
            when tiempo_medio <= 15 && ratio_medicos.between?(0.2, 0.333)
                2
            when ratio_medicos > 1
                3
            when ratio_medicos < 0.2
                1
            else
                0
        end
    end

    # Método para calcular el ratio de facultativos por paciente
    def ratio_facultativos_paciente
        num_pacientes = @camas.count { |cama| cama[:ocupada] }
        num_medicos = @medicos.length
        num_pacientes = 1 if num_pacientes.zero? # Evitar división por cero
        num_medicos.to_f / num_pacientes
    end

    # Método para dar de alta a un paciente.
    # @param paciente [Paciente] El paciente a dar de alta.
    # @param fecha_ingreso [Fecha] La fecha de ingreso del paciente.
    # @param hora_ingreso [Hora] La hora de ingreso del paciente.
    # @param fecha_alta [Fecha] La fecha de alta del paciente.
    # @param hora_alta [Hora] La hora de alta del paciente.
    def dar_alta_paciente(paciente, fecha_ingreso, hora_ingreso, fecha_alta, hora_alta)
        cama_ocupada = @camas.find { |cama| cama[:paciente] == paciente }
        if cama_ocupada
            cama_ocupada[:ocupada] = false
            cama_ocupada[:paciente] = nil
            cama_ocupada[:fecha_ingreso] = fecha_ingreso
            cama_ocupada[:hora_ingreso] = hora_ingreso
            cama_ocupada[:fecha_alta] = fecha_alta
            cama_ocupada[:hora_alta] = hora_alta
        else
            raise "El paciente no se encuentra en ninguna cama"
        end
    end

    # Método para calcular el ratio de pacientes por médico.
    def ratio_pacientes_medico
        num_pacientes = @camas.count { |cama| cama[:ocupada] }
        num_medicos = @medicos.length
        num_medicos = 1 if num_medicos.zero? # Evitar división por cero
        num_pacientes.to_f / num_medicos
    end
end
