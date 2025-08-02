require_relative '../lib/triaje/servicio_salud_hospitalizacion'
require "rspec"

RSpec.describe ServicioSaludHospitalizacion do
  let(:hora_apertura) { Hora.new(8, 0, 0) }
  let(:hora_cierre) { Hora.new(20, 0, 0) }
  let(:fecha_festivo) { Fecha.new(25, 12, 2023) }
  let(:medico) { Medico.new(1, "Juan", "Perez", "M", Fecha.new(1, 1, 1980), "general") }
  let(:paciente) { Paciente.new(1, "Ana", "Gomez", "F", Fecha.new(1, 1, 1990), 1) }
  let(:servicio_hospitalizacion) { ServicioSaludHospitalizacion.new(1, "Hospitalización", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10), 3) }

  before(:each) do
    @hora_entrada = Hora.new(10, 30, 0)
    @hora_salida = Hora.new(12, 0, 0)
    @fecha_entrada = Fecha.new(20, 7, 2021)
    @fecha_salida = Fecha.new(20, 8, 2021)
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
    @servicio_hospP11.asignar_paciente_cama(@paciente1P11)
    @servicio_hospP11.asignar_medico_paciente(@medico1P11, @paciente1P11)
    @servicio_hospP11.dar_alta_paciente(@paciente1P11, @fecha_entradaP11, @hora_entradaP11, @fecha_salidaP11, @hora_salidaP11)
    @servicio_urgP11.asignar_paciente_cama(@paciente1P11)
    @servicio_urgP11.asignar_medico_paciente(@medico3P11, @paciente1P11)
    @servicio_urgP11.asignar_medico_paciente(@medico4P11, @paciente1P11)
  end

  it "hereda de la clase ServicioSalud" do
    expect(servicio_hospitalizacion).to be_a(ServicioSalud)
    expect(ServicioSaludHospitalizacion.superclass).to eq(ServicioSalud)
    expect(ServicioSaludHospitalizacion.superclass.superclass).to eq(Object)
  end

  it "inicializa correctamente" do
    expect(servicio_hospitalizacion.id).to eq(1)
    expect(servicio_hospitalizacion.descripcion).to eq("Hospitalización")
    expect(servicio_hospitalizacion.horario_apertura).to eq(hora_apertura)
    expect(servicio_hospitalizacion.horario_cierre).to eq(hora_cierre)
    expect(servicio_hospitalizacion.festivos).to include(fecha_festivo)
    expect(servicio_hospitalizacion.medicos).to include(medico)
    expect(servicio_hospitalizacion.camas.size).to eq(10)
    expect(servicio_hospitalizacion.numero_plantas).to eq(3)
  end

  it "devuelve el metodo to_s correctamente" do
    expect(servicio_hospitalizacion.to_s).to eq("Id: 1, Servicio de Salud: Hospitalización, Horario de apertura: 8:0:0, Horario de cierre: 20:0:0, Festivos: 25/12/2023, Número de médicos: 1, Número de camas: 10, Número de plantas: 3")
  end

  it "asigna un paciente a una cama y verifica el número de camas libres" do
    servicio_hospitalizacion.asignar_paciente_cama(paciente)
    expect(servicio_hospitalizacion.camas_libres).to eq(9)
  end

  it "asigna un médico a un paciente y el numero de pacientes asignados" do
    servicio_hospitalizacion.asignar_paciente_cama(paciente)
    servicio_hospitalizacion.asignar_medico_paciente(medico, paciente)
    expect(servicio_hospitalizacion.numero_pacientes(medico)).to eq(1)
  end

  it "es comparable según el número de plantas" do
    servicio_hospitalizacion_2 = ServicioSaludHospitalizacion.new(2, "Hospitalización Especializada", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10), 5)
    expect(servicio_hospitalizacion < servicio_hospitalizacion_2).to be true
    expect(servicio_hospitalizacion > servicio_hospitalizacion_2).to be false
    expect(servicio_hospitalizacion <= servicio_hospitalizacion_2).to be true
    expect(servicio_hospitalizacion >= servicio_hospitalizacion_2).to be false
    expect(servicio_hospitalizacion == servicio_hospitalizacion_2).to be false
    expect(servicio_hospitalizacion.clamp(servicio_hospitalizacion, servicio_hospitalizacion_2)).to eq(servicio_hospitalizacion)
  end

  it "verifica el polimorfismo" do
    expect(servicio_hospitalizacion.respond_to?(:numero_plantas)).to be true
    expect(servicio_hospitalizacion.respond_to?(:camas_uci_disponibles)).to be false
  end

  it "calcula la duración de la ocupación de una cama" do
    fecha_ingreso = Fecha.new(1, 1, 2023)
    hora_ingreso = Hora.new(10, 0, 0)
    fecha_alta = Fecha.new(3, 1, 2023)
    hora_alta = Hora.new(12, 30, 0)
    duracion = servicio_hospitalizacion.duracion_ocupacion(fecha_ingreso, hora_ingreso, fecha_alta, hora_alta)
    expect(duracion).to eq({ dias: 2, horas: 2, minutos: 30 })
  end

  it "verifica el ratio pacientes/médico" do
    @servicio_hospP11.asignar_paciente_cama(@paciente1P11)
    @servicio_hospP11.asignar_medico_paciente(@medico1P11, @paciente1P11)
    ratio = @servicio_hospP11.ratio_pacientes_medico
    expect(ratio).to eq(0.5)
  end

  it "verifica el índice de capacidad de respuesta" do
    @servicio_hospP11.asignar_paciente_cama(@paciente1P11)
    @servicio_hospP11.asignar_medico_paciente(@medico1P11, @paciente1P11)
    indice = @servicio_hospP11.indice_capacidad_respuesta
    expect(indice).to eq(3)
  end
end