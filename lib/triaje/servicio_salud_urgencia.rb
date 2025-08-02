require_relative "servicio_salud"

# Clase que representa un servicio de salud de urgencia.
class ServicioSaludUrgencia < ServicioSalud
    include Comparable
    
    # Método de lectura para los atributos de la clase.
    # @return [Integer] camas_uci_disponibles.
    attr_reader :camas_uci_disponibles
    
    # Inicializa una nueva instancia de la clase 'Nivel'.
    # @param id [Integer] El identificador del servicio de salud.
    # @param descripcion [String] La descripción del servicio de salud.
    # @param horario_apertura [Hora] La hora de apertura del servicio de salud.
    # @param horario_cierre [Hora] La hora de cierre del servicio de salud.
    # @param festivos [Array] Los días
    # @param medicos [Array] Los médicos asignados al servicio de salud.
    # @param camas [Array] Las camas del servicio de salud.
    # @param camas_uci_disponibles [Integer] El número de camas uci disponibles.
    def initialize(id, descripcion, horario_apertura, horario_cierre, festivos = [], medicos = [], camas = [], camas_uci_disponibles)
        super(id, descripcion, horario_apertura, horario_cierre, festivos, medicos, camas)
        @camas_uci_disponibles = camas_uci_disponibles
    end

    # Compara 2 servicio de salud según el número de camas uci disponibles.
    # @param other [ServicioSaludUrgencia] Otra instancia de `ServicioSaludUrgencia` a comparar.
    def <=>(other)
        @camas_uci_disponibles <=> other.camas_uci_disponibles
    end

    # Método to_s para mostrar la información completa del servicio de salud de urgencia.
    #
    # @return [String] Información del servicio de salud de urgencia.
    def to_s
        super + ", Camas UCI disponibles: #{@camas_uci_disponibles}"
    end
end