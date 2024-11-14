# frozen_string_literal: true

require_relative "triaje/version"
require_relative "triaje/fecha.rb"
require_relative "triaje/set.rb"
require_relative "triaje/hora.rb"
require_relative "triaje/persona.rb"
require_relative "triaje/paciente.rb"
require_relative "triaje/medico.rb"
require_relative "triaje/titular.rb"

module Triaje
  
  # Constante que representa el nivel de reanimación (azul), atención inmediata.
  NIVEL_I = Set.new(1, "Azul", "Reanimación", 0)
  # Constante que representa el nivel de emergencia (rojo), atención en 7 minutos.
  NIVEL_II = Set.new(2, "Rojo", "Emergencia", 7)
  # Constante que representa el nivel urgente (naranja), atención en 30 minutos.
  NIVEL_III = Set.new(3, "Naranja", "Urgente", 30)
  # Constante que representa el nivel menos urgente (verde), atención en 45 minutos.
  NIVEL_IV = Set.new(4, "Verde", "Menos urgente", 45)
  # Constante que representa el nivel no urgente (negro), atención en 60 minutos.
  NIVEL_V = Set.new(5, "Negro", "No urgente", 60)

  # Calcula la diferencia en días, meses y años entre dos fechas.
  #
  # @param fecha1 [Fecha] Primera fecha.
  # @param fecha2 [Fecha] Segunda fecha.
  # @return [Hash] Diferencia en años, meses y días.
  # @example
  #   diferencia_en_fechas(fecha1, fecha2)
  #   # => { años: 2, meses: 3, días: 15 }
  def self.diferencia_en_fechas(fecha1, fecha2)
    anyos = fecha2.anyo - fecha1.anyo
    meses = fecha2.mes - fecha1.mes
    dias = fecha2.dia - fecha1.dia

    # Ajusta si los días o meses son negativos
    if dias < 0
      dias += 30
      meses -= 1
    end

    if meses < 0
      meses += 12
      anyos -= 1
    end

    { anyos: anyos, meses: meses, dias: dias }
  end

  # Calcula la diferencia en horas, minutos y segundos entre dos registros de tiempo.
  #
  # @param hora1 [Hora] Primer registro de tiempo.
  # @param hora2 [Hora] Segundo registro de tiempo.
  # @return [Hash] Diferencia en horas, minutos y segundos.
  # @example
  #   diferencia_en_horas_minutos_segundos(hora1, hora2)
  #   # => { horas: 2, minutos: 15, segundos: 45 }
  def self.diferencia_en_horas_minutos_segundos(hora1, hora2)
    horas = hora2.horas - hora1.horas
    minutos = hora2.minutos - hora1.minutos
    segundos = hora2.segundos - hora1.segundos

    # Ajusta si los segundos o minutos son negativos
    if segundos < 0
      segundos += 60
      minutos -= 1
    end

    if minutos < 0
      minutos += 60
      horas -= 1
    end

    { horas: horas, minutos: minutos, segundos: segundos }
  end

  # Determina el nivel de prioridad basado en la hora de entrada y la hora actual.
  #
  # @param hora_entrada [Hora] Hora de llegada del paciente.
  # @param hora_actual [Hora] Hora actual del sistema.
  # @return [NivelTriaje] Nivel de prioridad calculado.
  # @example
  #   obtener_prioridad(hora_entrada, hora_actual)
  #   # => NivelTriaje (nivel de triaje basado en el tiempo de espera)
  def self.obtener_prioridad(hora_entrada, hora_actual)
    diferencia = diferencia_en_horas_minutos_segundos(hora_entrada, hora_actual)
    total_minutos = diferencia[:horas] * 60 + diferencia[:minutos]

    case total_minutos
    when 0..7
      NIVEL_II.nivel
    when 8..30
      NIVEL_III.nivel
    when 31..45
      NIVEL_IV.nivel
    when 46..60
      NIVEL_V.nivel
    else
      NIVEL_I.nivel
    end
  end
end
