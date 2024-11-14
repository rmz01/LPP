# Clase Fecha que representa una fecha, con atributos para dia, mes y año.
class Fecha
    # Método de lectura para los atributos de la clase.
    # @return [Integer] dia, mes o año.
    attr_reader :dia, :mes, :anyo
    
    # Inicializa una nueva instancia de la clase 'Fecha'.
    #
    # @param dia [Integer] El día del mes (1 a 31) - variable local.
    # @param mes [Integer] El mes (1 a 12) - variable local.
    # @param anyo [Integer] El año (0 a ∞) - variable local.
    def initialize(dia, mes, anyo)
      # @dia, @mes y @anyo son variables de instancia.
      @dia = dia
      @mes = mes
      @anyo = anyo
    end
    
    # Devuelve la representación en cadena de la fecha en formato "dd:mm:aaaa".
    #
    # @return [String] La hora en formato `dd:mm:aaaa`.
    def to_s
        format("%02d/%02d/%04d", @dia, @mes, @anyo)
    end

    # Compara si otra instancia de `Fecha` es igual a esta instancia
    # basándose en el día, mes y año.
    # @param other [Fecha] Otra instancia de `Fecha` a comparar.
    # @return [Boolean] `true` si las instancias tienen los mismos atributos, de lo contrario `false`.
    def ==(other)
        return false unless other.is_a?(Fecha)
        @dia == other.dia &&
        @mes == other.mes &&
        @anyo == other.anyo
    end    
end