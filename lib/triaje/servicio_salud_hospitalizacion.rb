require_relative "servicio_salud"

# Clase que representa un servicio de salud de hospitalización.
class ServicioSaludHospitalizacion < ServicioSalud
    include Comparable

    # Método de lectura para los atributos de la clase.
    # @return [Integer] numero_plantas.
    attr_reader :numero_plantas

    # Inicializa una nueva instancia de la clase 'Nivel'.
    #
    # @param id [Integer] El identificador del servicio de salud.
    # @param descripcion [String] La descripción del servicio de salud.
    # @param horario_apertura [Hora] La hora de apertura del servicio de salud.
    # @param horario_cierre [Hora] La hora de cierre del servicio de salud.
    # @param festivos [Array] Los días
    # @param medicos [Array] Los médicos asignados al servicio de salud.
    # @param camas [Array] Las camas del servicio de salud.
    # @param numero_plantas [Integer] El número de plantas del servicio de salud.
    def initialize(id, descripcion, horario_apertura, horario_cierre, festivos = [], medicos = [], camas = [], numero_plantas)
        super(id, descripcion, horario_apertura, horario_cierre, festivos, medicos, camas)
        @numero_plantas = numero_plantas
    end

    # Compara 2 servicio de salud según el número de plantas.
    # @param other [ServicioSaludHospitalizacion] Otra instancia de `ServicioSaludHospitalizacion` a comparar.
    def <=>(other)
        @numero_plantas <=> other.numero_plantas
    end

    # Método to_s para mostrar la información completa del servicio de salud de hospitalizacion.
    #
    # @return [String] Información del servicio de salud de hospitalizacion..
    def to_s
        super + ", Número de plantas: #{@numero_plantas}"
    end
end