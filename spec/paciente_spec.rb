# spec/paciente_spec.rb

require 'rspec'
require_relative '../lib/triaje/paciente'
require_relative '../lib/triaje/fecha'
require_relative '../lib/triaje'

RSpec.describe Paciente do
  before(:each) do
    @prioridad = Triaje::NIVEL_II
    @diagnosticos = ["leve", "grave"]
    @paciente = Paciente.new(1, "Carlos", "López", "M", Fecha.new(20, 7, 1990), @prioridad, @diagnosticos)
    @otro_paciente = Paciente.new(2, "Ana", "Martínez", "F", Fecha.new(15, 5, 1985), Triaje::NIVEL_III, ["alta", "muy grave"])
  end

  describe 'herencia de Persona' do
    it 'verifica que la clase de @paciente sea Paciente' do
      expect(@paciente.class).to eq(Paciente)
    end

    it 'verifica que la superclase de Paciente sea Persona' do
      expect(@paciente.class.superclass).to eq(Persona)
    end
  end

  describe 'acceso público' do
    it 'verifica que prioridad y diagnosticos sean accesibles públicamente' do
      expect(@paciente.prioridad).to eq(@prioridad)
      expect(@paciente.diagnosticos).to eq(["leve", "grave"])
    end

    it 'verifica que id, sexo y edad sean accesibles públicamente desde Persona' do
      expect(@paciente.id).to eq(1)
      expect(@paciente.sexo).to eq("M")
      expect(@paciente.edad).to eq(Date.today.year - 1990)
    end
  end

  describe '#ultimo_diagnostico' do
    it 'devuelve el último diagnóstico asignado al paciente' do
      expect(@paciente.ultimo_diagnostico).to eq("grave")
      expect(@otro_paciente.ultimo_diagnostico).to eq("muy grave")
    end
  end

  describe '#==' do
    it 'verifica que dos objetos Paciente con los mismos atributos sean iguales' do
      paciente_identico = Paciente.new(1, "Carlos", "López", "M", Fecha.new(20, 7, 1990), @prioridad, @diagnosticos)
      expect(@paciente).to eq(paciente_identico)
    end

    it 'verifica que dos objetos Paciente con diferentes atributos no sean iguales' do
      expect(@paciente).not_to eq(@otro_paciente)
    end
  end

  describe 'visibilidad privada' do
    it 'comprueba que el acceso directo a nombre y apellido provoque un error' do
      expect { @paciente.nombre }.to raise_error(NoMethodError)
      expect { @paciente.apellido }.to raise_error(NoMethodError)
    end
  end

  describe 'visibilidad protegida' do
    it 'comprueba que el acceso directo a fecha_nacimiento desde una instancia externa provoque un error' do
      expect { @paciente.fecha_nacimiento }.to raise_error(NoMethodError)
    end
  end

  describe '#to_s' do
    it 'devuelve la cadena en el formato esperado' do
      expected_string = "ID: 1, Nombre completo: Carlos López, Sexo: M, Nacimiento: 20/7/1990, Prioridad: #{@prioridad}, Diagnósticos: leve, grave"
      expect(@paciente.to_s).to eq(expected_string)
    end
  end

  describe '#asignar_diagnostico' do
    it 'asigna un diagnóstico válido al paciente' do
      @paciente.asignar_diagnostico("alta")
      expect(@paciente.ultimo_diagnostico).to eq("alta")
      @paciente.asignar_diagnostico("muy grave")
      expect(@paciente.ultimo_diagnostico).to eq("muy grave")
    end

    it 'lanza un error si se asigna un diagnóstico no válido' do
      expect { @paciente.asignar_diagnostico("invalido") }.to raise_error(ArgumentError, "Diagnóstico no válido. Los diagnósticos permitidos son: alta, leve, grave, muy grave.")
    end
  end

  # Pruebas para Comparable
  describe 'Paciente comparable' do
    it 'comprobando si paciente es comparable' do
      expect(@paciente).to be_a(Comparable)
    end

    it 'compara dos pacientes correctamente usando <, <=, >, >=, between?, clamp' do
      expect(@paciente < @otro_paciente).to be true
      expect(@paciente <= @otro_paciente).to be true
      expect(@paciente > @otro_paciente).to be false
      expect(@paciente >= @otro_paciente).to be false
      expect(@paciente.between?(@paciente, @otro_paciente)).to be true
      expect(@paciente.clamp(@paciente, @otro_paciente)).to eq(@paciente)
    end
  end

  # Pruebas para Enumerable
  describe "Enumerable" do 
    it 'comproando si paciente es enumerable' do
      expect(@paciente).to be_a(Enumerable)
    end
    
    it "comprueba que se pueda usar el metodo any? con Paciente" do
      expect(@paciente.any? { |attr| attr == "Carlos López" }).to be true
    end

    it "comprueba que se pueda usar el metodo none? con Paciente" do
      expect(@paciente.none? { |attr| attr == "Inexistente" }).to be true
    end

    it "comprueba que se pueda usar el metodo count con Paciente" do
      expect(@paciente.count).to eq(6)
    end

    it "comprueba que se pueda usar el metodo include? con Paciente" do
      expect(@paciente.include?("Carlos López")).to be true
    end

    it "comprueba que se pueda usar el metodo all? con Paciente" do
      expect(@paciente.all? { |attr| !attr.nil? }).to be true
    end
  end
end