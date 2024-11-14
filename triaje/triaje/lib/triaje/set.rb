# Clase Set que representa un conjunto de nivel, color, categoría y tiempo de espera.
class Set
    # Método de lectura para los atributos de la clase.
    # @return [Integer] nivel y tiempo_espera.
    # @return [String] color.
    # @return [String] categoria.
    attr_reader :nivel, :color, :categoria, :tiempo_espera
    
    # Inicializa una nueva instancia de la clase 'Set'.
    #
    # @param nivel [Integer] El nivel de prioridad del paciente.
    # @param color [String] El color de la categoría del paciente.
    # @param categoria [String] La categoría del paciente.
    # @param tiempo_espera [Integer] El tiempo de espera del paciente.
    def initialize(nivel, color, categoria, tiempo_espera)
        # @nivel, @color, @categoria y @tiempo_espera son variables de instancia.
        @nivel = nivel
        @color = color
        @categoria = categoria
        @tiempo_espera = tiempo_espera
    end
    
    # Método to_s para mostrar la información completa del nivel de triaje.
    #
    # @return [String] Información del nivel en el formato especificado.
    def to_s
        "Nivel: #{@nivel}, Color: #{@color}, Categoría: #{@categoria}, Tiempo de espera: #{@tiempo_espera} minutos"
    end
end