require_relative '../lib/triaje/servicio_salud_urgencia'
require "rspec"

RSpec.describe ServicioSaludUrgencia do
  let(:hora_apertura) { Hora.new(8, 0, 0) }
  let(:hora_cierre) { Hora.new(20, 0, 0) }
  let(:fecha_festivo) { Fecha.new(25, 12, 2023) }
  let(:medico) { Medico.new(1, "Juan", "Perez", "M", Fecha.new(1, 1, 1980), "general") }
  let(:paciente) { Paciente.new(1, "Ana", "Gomez", "F", Fecha.new(1, 1, 1990), 1) }
  let(:servicio_urgencia) { ServicioSaludUrgencia.new(1, "Urgencias", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10), 5) }

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
    @servicio_hospP11.dar_alta_paciente(@paciente1P11, @fecha_entradaP11, @hora_entradaP11, @fecha_salidaP11, @hora_salidaP11)
    @servicio_urgP11.asignar_paciente_cama(@paciente1P11)
    @servicio_urgP11.asignar_medico_paciente(@medico3P11, @paciente1P11)
    @servicio_urgP11.asignar_medico_paciente(@medico4P11, @paciente1P11)
  end

  it "hereda de la clase ServicioSalud" do
    expect(servicio_urgencia).to be_a(ServicioSalud)
    expect(ServicioSaludUrgencia.superclass).to eq(ServicioSalud)
    expect(ServicioSaludUrgencia.superclass.superclass).to eq(Object)
  end

  it "inicializa correctamente" do
    expect(servicio_urgencia.id).to eq(1)
    expect(servicio_urgencia.descripcion).to eq("Urgencias")
    expect(servicio_urgencia.horario_apertura).to eq(hora_apertura)
    expect(servicio_urgencia.horario_cierre).to eq(hora_cierre)
    expect(servicio_urgencia.festivos).to include(fecha_festivo)
    expect(servicio_urgencia.medicos).to include(medico)
    expect(servicio_urgencia.camas.size).to eq(10)
    expect(servicio_urgencia.camas_uci_disponibles).to eq(5)
  end

  it "devuelve el metodo to_s correctamente" do
    expect(servicio_urgencia.to_s).to eq("Id: 1, Servicio de Salud: Urgencias, Horario de apertura: 8:0:0, Horario de cierre: 20:0:0, Festivos: 25/12/2023, Número de médicos: 1, Número de camas: 10, Camas UCI disponibles: 5")
  end

  it "asigna un paciente a una cama y verifica el número de camas libres" do
    servicio_urgencia.asignar_paciente_cama(paciente)
    expect(servicio_urgencia.camas_libres).to eq(9)
  end

  it "asigna un médico a un paciente y el numero de pacientes asignados" do
    servicio_urgencia.asignar_paciente_cama(paciente)
    servicio_urgencia.asignar_medico_paciente(medico, paciente)
    expect(servicio_urgencia.numero_pacientes(medico)).to eq(1)
  end

  it "es comparable según el número de camas UCI disponibles" do
    servicio_urgencia_2 = ServicioSaludUrgencia.new(2, "Urgencias Especializadas", hora_apertura, hora_cierre, [fecha_festivo], [medico], Array.new(10), 10)
    expect(servicio_urgencia < servicio_urgencia_2).to be true
    expect(servicio_urgencia > servicio_urgencia_2).to be false
    expect(servicio_urgencia <= servicio_urgencia_2).to be true
    expect(servicio_urgencia >= servicio_urgencia_2).to be false
    expect(servicio_urgencia == servicio_urgencia_2).to be false
    expect(servicio_urgencia.clamp(servicio_urgencia, servicio_urgencia_2)).to eq(servicio_urgencia)
  end

  it "verifica el polimorfismo" do
    expect(servicio_urgencia.respond_to?(:camas_uci_disponibles)).to be true
    expect(servicio_urgencia.respond_to?(:numero_plantas)).to be false
  end

  it "calcula la duración de la ocupación de una cama" do
    fecha_ingreso = Fecha.new(1, 1, 2023)
    hora_ingreso = Hora.new(10, 0, 0)
    fecha_alta = Fecha.new(3, 1, 2023)
    hora_alta = Hora.new(12, 30, 0)
    duracion = servicio_urgencia.duracion_ocupacion(fecha_ingreso, hora_ingreso, fecha_alta, hora_alta)
    expect(duracion).to eq({ dias: 2, horas: 2, minutos: 30 })
  end

  it "verifica el ratio pacientes/médico" do
    @servicio_urgP11.asignar_paciente_cama(@paciente1P11)
    @servicio_urgP11.asignar_medico_paciente(@medico3P11, @paciente1P11)
    ratio = @servicio_urgP11.ratio_pacientes_medico
    expect(ratio).to eq(1.0)
  end

  it "verifica el índice de capacidad de respuesta" do
    @servicio_urgP11.asignar_paciente_cama(@paciente1P11)
    @servicio_urgP11.asignar_medico_paciente(@medico3P11, @paciente1P11)
    indice = @servicio_urgP11.indice_capacidad_respuesta
    expect(indice).to eq(3)
  end
end