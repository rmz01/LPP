# spec/medico_spec.rb

require 'rspec'
require_relative '../lib/triaje/medico'
require_relative '../lib/triaje/paciente'
require_relative '../lib/triaje/fecha'
require_relative '../lib/triaje/nivel'

RSpec.describe Medico do
  before(:each) do
    fecha_nacimiento = Fecha.new(10, 5, 1980)
    @paciente_1 = Paciente.new(1, "Juan", "Pérez", "M", fecha_nacimiento, Triaje::NIVEL_II, ["grave", "moderado"])
    @paciente_2 = Paciente.new(2, "Ana", "García", "F", fecha_nacimiento, Triaje::NIVEL_III, ["leve", "moderado"])
    @paciente_3 = Paciente.new(3, "Pedro", "López", "M", fecha_nacimiento, Triaje::NIVEL_IV, ["moderado", "grave"])
    @medico1 = Medico.new(1, "Carlos", "Gomez", "M", fecha_nacimiento, "general", [@paciente_1, @paciente_2])
    @medico2 = Medico.new(2, "Ana", "Martínez", "F", fecha_nacimiento, "pediatría", [@paciente_3])
  end

  describe '#numero_pacientes_asignados' do
    it 'verifica que el número de pacientes asignados sea correcto' do
      expect(@medico1.numero_pacientes_asignados).to eq(2)
      expect(@medico2.numero_pacientes_asignados).to eq(1)
    end
  end

  describe '#asignar_paciente' do
    it 'verifica que el método de asignación de pacientes funcione correctamente' do
      @medico1.asignar_paciente(@paciente_3)
      expect(@medico1.pacientes_asignados).to include(@paciente_3)
    end
  end

  describe '#to_s' do
    it 'verifica la conversión a cadena para el médico' do
      expect(@medico1.to_s).to eq("Carlos Gomez (Especialidad: general), Número de pacientes: 2")
    end
  end

  describe '#especialidad' do
    it 'verifica la especialidad del médico' do
      expect(@medico1.especialidad).to eq("general")
    end
  end

  describe '#pacientes_asignados' do
    it 'verifica la lista de pacientes asignados al médico' do
      expect(@medico1.pacientes_asignados).to eq([@paciente_1, @paciente_2])
      expect(@medico2.pacientes_asignados).to eq([@paciente_3])
    end
  end

  describe '#==' do
    it 'verifica la igualdad entre dos objetos Medico con los mismos atributos' do
      medico_identico = Medico.new(1, "Carlos", "Gomez", "M", Fecha.new(10, 5, 1980), "general", [@paciente_1, @paciente_2])
      expect(@medico1).to eq(medico_identico)
    end

    it 'verifica que dos objetos Medico con diferentes atributos no sean iguales' do
      expect(@medico1).not_to eq(@medico2)
    end
  end

  describe 'herencia de Persona' do
    it 'verifica que la clase de @medico1 sea Medico' do
      expect(@medico1.class).to eq(Medico)
    end

    it 'verifica que la superclase de Medico sea Persona' do
      expect(@medico1.class.superclass).to eq(Persona)
    end
  end

  describe 'visibilidad privada' do
    it 'comprueba que el acceso directo a nombre y apellido provoque un error' do
      expect { @medico1.nombre }.to raise_error(NoMethodError)
      expect { @medico1.apellido }.to raise_error(NoMethodError)
    end
  end

  describe 'visibilidad protegida' do
    it 'comprueba que el acceso directo a fecha_nacimiento desde una instancia externa provoque un error' do
      expect { @medico1.fecha_nacimiento }.to raise_error(NoMethodError)
    end
  end

  # Prueba para Comparable
  describe 'Medico comparable' do
    it 'verifica que Medico sea comparable' do
      expect(@medico1).to be_a(Comparable)
    end

    it 'verifica el orden de los medicos con <, <=, >, >=, between?, clamp' do
      expect(@medico1 > @medico2).to eq(true)
      expect(@medico1 >= @medico2).to eq(true)
      expect(@medico1 < @medico2).to eq(false)
      expect(@medico1 <= @medico2).to eq(false)
      expect(@medico1.between?(@medico2, @medico1)).to eq(true)
      expect(@medico1.clamp(@medico2, @medico1)).to eq(@medico1)
    end
  end

  # Pruebas para Enumerable
  describe "Medico Enumerable" do 
    it "comprueba que Medico sea enumerable" do
      expect(@medico1).to be_a(Enumerable)
    end
    
    it "comprueba que se pueda recorrer la instancia de Medico" do
      expect(@medico1.map { |attr| attr }).to eq([1, "Carlos Gomez", "M", Fecha.new(10, 5, 1980), "general", [@paciente_1, @paciente_2]])
    end

    it "comprueba que se pueda usar el metodo each con Medico" do
      attributes = []
      @medico1.each { |attr| attributes << attr }
      expect(attributes).to eq([1, "Carlos Gomez", "M", Fecha.new(10, 5, 1980), "general", [@paciente_1, @paciente_2]])
    end

    it "comprueba que se pueda usar el metodo select con Medico" do
      expect(@medico1.select { |attr| attr.is_a?(String) }).to eq(["Carlos Gomez", "M", "general"])
    end

    it "comprueba que se pueda usar el metodo find con Medico" do
      expect(@medico1.find { |attr| attr == "Carlos Gomez" }).to eq("Carlos Gomez")
    end

    it "comprueba que se pueda usar el metodo all? con Medico" do
      expect(@medico1.all? { |attr| !attr.nil? }).to be true
    end
  end
end