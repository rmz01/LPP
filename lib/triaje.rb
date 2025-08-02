# frozen_string_literal: true

require_relative "triaje/version"
require_relative "triaje/fecha"
require_relative "triaje/hora"
require_relative "triaje/nivel"
require_relative "triaje/persona"
require_relative "triaje/paciente"
require_relative "triaje/medico"
require_relative "triaje/titular"
require_relative "triaje/servicio_salud"
require_relative "triaje/servicio_salud_urgencia"
require_relative "triaje/servicio_salud_hospitalizacion"

# El módulo Triaje contiene métodos y constantes relacionadas con el sistema de triaje.
module Triaje
  class Error < StandardError; end

  # Constantes que representan los niveles de triaje.
  NIVEL_I = Nivel.new(1, "Azul", "Reanimación", 0)
  NIVEL_II = Nivel.new(2, "Rojo", "Emergencia", 7)
  NIVEL_III = Nivel.new(3, "Naranja", "Urgente", 30)
  NIVEL_IV = Nivel.new(4, "Verde", "Menos urgente", 45)
  NIVEL_V = Nivel.new(5, "Negro", "No urgente", 60)

  # Calcula la diferencia en días, meses y años entre dos fechas.
  #
  # @param date1 [Date] La primera fecha.
  # @param date2 [Date] La segunda fecha.
  # @return [Hash] Un hash con las claves :days, :months y :years.
  def self.date_difference(date1, date2)
    days = (date2 - date1).to_i
    months = (date2.year * 12 + date2.month) - (date1.year * 12 + date1.month)
    years = date2.year - date1.year
    { days: days, months: months, years: years }
  end

  # Calcula la diferencia en horas, minutos y segundos entre dos tiempos.
  #
  # @param time1 [Time] El primer tiempo.
  # @param time2 [Time] El segundo tiempo.
  # @return [Hash] Un hash con las claves :hours, :minutes y :seconds.
  def self.time_difference(time1, time2)
    diff = time2 - time1
    hours = (diff / 3600).to_i
    minutes = ((diff % 3600) / 60).to_i
    seconds = (diff % 60).to_i
    { hours: hours, minutes: minutes, seconds: seconds }
  end

  # Devuelve el nivel de prioridad basado en la hora de entrada y la hora actual.
  #
  # @param entry_time [Time] La hora de entrada.
  # @param current_time [Time] La hora actual.
  # @return [String] La categoría del nivel de triaje correspondiente.
  def self.priority_level(entry_time, current_time)
    diff_minutes = ((current_time - entry_time) / 60).to_i
    case diff_minutes
    when 0..7
      NIVEL_II.categoria
    when 8..30
      NIVEL_III.categoria
    when 31..45
      NIVEL_IV.categoria
    when 46..60
      NIVEL_V.categoria
    else
      NIVEL_I.categoria
    end
  end

  # Fusiona dos servicios de salud en uno solo.
  def self.merge_services(service1, service2)
    id = service1.id + service2.id
    descripcion = "#{service1.descripcion} y #{service2.descripcion}"
    horario_apertura = [service1.horario_apertura, service2.horario_apertura].min
    horario_cierre = [service1.horario_cierre, service2.horario_cierre].max
    festivos = (service1.festivos + service2.festivos).uniq
    medicos = (service1.medicos + service2.medicos).uniq
    camas = service1.camas + service2.camas

    if service1.is_a?(ServicioSaludUrgencia) && service2.is_a?(ServicioSaludUrgencia)
      camas_uci_disponibles = service1.camas_uci_disponibles + service2.camas_uci_disponibles
      return ServicioSaludUrgencia.new(id, descripcion, horario_apertura, horario_cierre, festivos, medicos, camas, camas_uci_disponibles)
    elsif service1.is_a?(ServicioSaludHospitalizacion) && service2.is_a?(ServicioSaludHospitalizacion)
      numero_plantas = service1.numero_plantas + service2.numero_plantas
      return ServicioSaludHospitalizacion.new(id, descripcion, horario_apertura, horario_cierre, festivos, medicos, camas, numero_plantas)
    else
      return ServicioSalud.new(id, descripcion, horario_apertura, horario_cierre, festivos, medicos, camas)
    end
  end

  # Selecciona el servicio sanitario con el mayor índice de capacidad de respuesta
  def self.servicio_mayor_indice_respuesta(servicios)
      servicios.max
  end

  # Selecciona el servicio sanitario con camas UCI que tiene el mayor índice de capacidad de respuesta
  def self.servicio_uci_mayor_indice_respuesta(servicios)
      servicios_uci = servicios.select { |servicio| servicio.is_a?(ServicioSaludUrgencia) }
      servicios_uci.max
  end

  # Calcula el porcentaje de camas libres de cada servicio sanitario
  def self.porcentaje_camas_libres(servicios)
      servicios.map { |servicio| (servicio.camas_libres.to_f / servicio.camas.length) * 100 }
  end

  # Calcula el porcentaje de facultativos de cada especialidad de cada servicio sanitario
  def self.porcentaje_facultativos_por_especialidad(servicios)
    especialidades = Medico::ESPECIALIDADES_VALIDAS
    servicios.map do |servicio, result|
      total_medicos = servicio.medicos.length.to_f
      result[servicio] = especialidades.map do |especialidad, hash|
        medicos_especialidad = servicio.medicos.count { |medico| medico.especialidad == especialidad }
        hash[especialidad] = (medicos_especialidad / total_medicos) * 100
      end
    end
  end
end