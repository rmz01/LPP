# frozen_string_literal: true

require "spec_helper"
require "date"
require "time"
require_relative '../lib/triaje/servicio_salud'
require_relative '../lib/triaje/servicio_salud_urgencia'
require_relative '../lib/triaje/servicio_salud_hospitalizacion'

# Pruebas para el módulo Triaje y sus métodos.
RSpec.describe Triaje do
  def setup
    camas1 = Array.new(5)
    camas2 = Array.new(10)
    @medico1 = Medico.new(1, "Ana", "Martínez", "femenino", Fecha.new(1980, 10, 5), "pediatría", [])
    @medico2 = Medico.new(2, "Pedro", "López", "masculino", Fecha.new(1978, 5, 5), "geriatría", [])
    @medico3 = Medico.new(3, "María", "García", "femenino", Fecha.new(1960, 10, 23), "general", [])
    @medico4 = Medico.new(4, "Juan", "Pérez", "masculino", Fecha.new(1995, 7, 21), "general", [])
    @medico5 = Medico.new(5, "Carlos", "Gómez", "masculino", Fecha.new(1980, 9, 17), "general", [])
    @servicio1 = ServicioSalud.new(1, "Hospital General", Hora.new(8, 30, 30), Hora.new(20, 0, 0), ["25/12/2021"], [@medico1, @medico2, @medico3], camas2)
    @servicio2 = ServicioSalud.new(2, "Hospital Infantil", Hora.new(9, 0, 0), Hora.new(19, 30, 0), ["01/01/2022"], [@medico4, @medico5], camas1)
    @servicio_urgencia1 = ServicioSaludUrgencia.new(1, "Hospital General", Hora.new(8, 30, 30), Hora.new(20, 0, 0), ["25/12/2021"], [@medico1, @medico2, @medico3], camas2, 3)
    @servicio_urgencia2 = ServicioSaludUrgencia.new(2, "Hospital Infantil", Hora.new(9, 0, 0), Hora.new(19, 30, 0), ["01/01/2022"], [@medico4, @medico5], camas1, 7)
    @servicio_hospitalizacion1 = ServicioSaludHospitalizacion.new(1, "Hospital General", Hora.new(8, 30, 30), Hora.new(20, 0, 0), ["25/12/2021"], [@medico1, @medico2, @medico3], camas2, 3)
    @servicio_hospitalizacion2 = ServicioSaludHospitalizacion.new(2, "Hospital Infantil", Hora.new(9, 0, 0), Hora.new(19, 30, 0), ["01/01/2022"], [@medico4, @medico5], camas1, 7)
    ## PRUEBAS PRÁCTICA 11
    @medico1P11 = Titular.new(2005001, "Dr.", "Poo", "femenino", Fecha.new(1, 1, 1990), "geriatría", [], 20)
    @medico2P11 = Titular.new(2005002, "Dr.", "Fup", "masculino", Fecha.new(1, 1, 1995), "general", [], 10)
    @medico3P11 = Titular.new(2005003, "Dr.", "Struct", "femenino", Fecha.new(1, 1, 1980), "pediatría", [], 5)
    @medico4P11 = Titular.new(2005004, "Dr.", "Single", "masculino", Fecha.new(1, 1, 1975), "general", [], 15)
    @paciente1P11 = Paciente.new(2024001, "Paciente", "Tos", "masculino", Fecha.new(2, 12, 1935), Triaje::NIVEL_II, ["leve", "alta"])
    @hora_entradaP11 = Hora.new(12, 0, 0)
    @hora_salidaP11 = Hora.new(12, 15, 0)
    @fecha_entradaP11 = Fecha.new(11, 12, 2024)
    @fecha_salidaP11 = Fecha.new(11, 12, 2024)
    @servicio_hospP11 = ServicioSaludHospitalizacion.new("CIF012345678", "Hospital LPP", Hora.new(5, 0, 0), Hora.new(22, 0, 0), ["1/12/2024"], [@medico1P11, @medico2P11], Array.new(2), 5)
    @servicio_urgP11 = ServicioSaludUrgencia.new("CIF876543210", "Urgencias LPP", Hora.new(0, 0, 0), Hora.new(24, 0, 0), [], [@medico3P11, @medico4P11], Array.new(2), 1)
    @servicio_hospP11.asignar_paciente_cama(@paciente1P11, @hora_entradaP11, @hora_salidaP11, @fecha_entradaP11, @fecha_salidaP11)
    @servicio_hospP11.asignar_medico_paciente(@medico1P11, @paciente1P11)
  end

  # Prueba para el método Triaje.date_difference
  it "calculates the difference in days, months, and years between two dates" do
    date1 = Date.new(2023, 1, 1)
    date2 = Date.new(2023, 12, 31)
    expect(Triaje.date_difference(date1, date2)).to eq({ days: 364, months: 11, years: 0 })
  end

  # Prueba para el método Triaje.time_difference
  it "calculates the difference in hours, minutes, and seconds between two times" do
    time1 = Time.new(2023, 1, 1, 12, 0, 0)
    time2 = Time.new(2023, 1, 1, 14, 30, 45)
    expect(Triaje.time_difference(time1, time2)).to eq({ hours: 2, minutes: 30, seconds: 45 })
  end

  # Prueba para el método Triaje.priority_level
  it "returns the correct priority level based on entry time and current time" do
    entry_time = Time.new(2023, 1, 1, 12, 0, 0)
    current_time = Time.new(2023, 1, 1, 12, 5, 0)
    expect(Triaje.priority_level(entry_time, current_time)).to eq("Emergencia")
  end

  # Pruebas para la funcionalidad de fusión de servicios
  let(:hora_apertura) { Hora.new(8, 0, 0) }
  let(:hora_cierre) { Hora.new(20, 0, 0) }
  let(:fecha_festivo) { Fecha.new(25, 12, 2023) }
  let(:medico) { Medico.new(1, "Juan", "Perez", "M", Fecha.new(1, 1, 1980), "general") }
  let(:paciente) { Paciente.new(1, "Ana", "Gomez", "F", Fecha.new(1, 1, 1990), 1) }
  let(:servicio_urgencia) { ServicioSaludUrgencia.new(2, "Urgencias", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10), 5) }
  let(:servicio_hospitalizacion) { ServicioSaludHospitalizacion.new(3, "Hospitalización", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10), 3) }

  it "fusiona dos servicios de urgencias correctamente" do
    servicio_urgencia_2 = ServicioSaludUrgencia.new(4, "Urgencias Especializadas", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10), 7)
    servicio_fusionado = Triaje.merge_services(servicio_urgencia, servicio_urgencia_2)
    expect(servicio_fusionado.descripcion).to eq("Urgencias y Urgencias Especializadas")
    expect(servicio_fusionado.camas_uci_disponibles).to eq(12)
  end

  it "fusiona dos servicios de hospitalización correctamente" do
    servicio_hospitalizacion_2 = ServicioSaludHospitalizacion.new(5, "Hospitalización Avanzada", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10), 4)
    servicio_fusionado = Triaje.merge_services(servicio_hospitalizacion, servicio_hospitalizacion_2)
    expect(servicio_fusionado.descripcion).to eq("Hospitalización y Hospitalización Avanzada")
    expect(servicio_fusionado.numero_plantas).to eq(7)
  end

  it "fusiona un servicio de urgencias y uno de hospitalización correctamente" do
    servicio_fusionado = Triaje.merge_services(servicio_urgencia, servicio_hospitalizacion)
    expect(servicio_fusionado.descripcion).to eq("Urgencias y Hospitalización")
    expect(servicio_fusionado.camas.size).to eq(20)
  end

  # Pruebas para los nuevos métodos
  it "selecciona el servicio sanitario con el mayor índice de capacidad de respuesta" do
    servicio1 = ServicioSalud.new(1, "General", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10))
    servicio2 = ServicioSalud.new(2, "Especializado", hora_apertura, hora_cierre, [fecha_festivo], [medico, medico], Array.new(10))
    expect(Triaje.servicio_mayor_indice_respuesta([servicio1, servicio2])).to eq(servicio2)
  end

  it "selecciona el servicio sanitario con camas UCI que tiene el mayor índice de capacidad de respuesta" do
    servicio_uci1 = ServicioSaludUrgencia.new(1, "Urgencias 1", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10), 5)
    servicio_uci2 = ServicioSaludUrgencia.new(2, "Urgencias 2", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10), 10)
    expect(Triaje.servicio_uci_mayor_indice_respuesta([servicio_uci1, servicio_uci2])).to eq(servicio_uci2)
  end

  it "calcula el porcentaje de camas libres de cada servicio sanitario" do
    servicio1 = ServicioSalud.new(1, "General", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10))
    servicio2 = ServicioSalud.new(2, "Especializado", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(5))
    servicio1.asignar_paciente_cama(paciente)
    expect(Triaje.porcentaje_camas_libres([servicio1, servicio2])).to eq([90.0, 100.0])
  end
end