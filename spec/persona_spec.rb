# spec/persona_spec.rb

require 'rspec'
require_relative '../lib/triaje/persona'
require_relative '../lib/triaje/fecha'

RSpec.describe Persona do
  before(:each) do
    # Restablecer el contador de instancias antes de cada prueba
    Persona.class_variable_set(:@@numero_instancias, 0)
    @persona = Persona.new(1, "Juan", "Pérez", "M", Fecha.new(10, 5, 1990))
    @otra_persona = Persona.new(2, "Ana", "García", "F", Fecha.new(15, 6, 1985))
  end

  describe '#nombre_completo' do
    it 'devuelve el nombre y apellido correctamente concatenados' do
      expect(@persona.nombre_completo).to eq("Juan Pérez")
    end
  end

  describe '#edad' do
    it 'devuelve la edad correcta en base a la fecha actual' do
      expect(@persona.edad).to eq(Date.today.year - 1990)
    end
  end

  describe '#to_s' do
    it 'devuelve la cadena en el formato esperado' do
      expect(@persona.to_s).to eq("ID: 1, Nombre: Juan Pérez, Apellido: Pérez, Sexo: M, Fecha de Nacimiento: 10/5/1990")
    end
  end

  describe '#==' do
    it 'verifica que dos objetos Persona con los mismos atributos sean iguales' do
      persona_identica = Persona.new(1, "Juan", "Pérez", "M", Fecha.new(10, 5, 1990))
      expect(@persona).to eq(persona_identica)
    end

    it 'verifica que dos objetos Persona con diferentes atributos no sean iguales' do
      expect(@persona).not_to eq(@otra_persona)
    end
  end

  describe 'visibilidad privada' do
    it 'comprueba que el acceso directo a nombre y apellido provoque un error' do
      expect { @persona.nombre }.to raise_error(NoMethodError)
      expect { @persona.apellido }.to raise_error(NoMethodError)
    end
  end

  describe 'visibilidad protegida' do
    it 'comprueba que el acceso directo a fecha_nacimiento desde una instancia externa provoque un error' do
      expect { @persona.fecha_nacimiento }.to raise_error(NoMethodError)
    end
  end

  describe 'acceso público' do
    it 'verifica que id, sexo y edad sean accesibles públicamente' do
      expect(@persona.id).to eq(1)
      expect(@persona.sexo).to eq("M")
      expect(@persona.edad).to eq(Date.today.year - 1990)
    end
  end

  describe 'numero de instancias' do
    it 'verifica que el número de instancias creadas sea correcto' do
      expect(Persona.numero_instancias).to eq(2)
      nueva_persona = Persona.new(3, "Carlos", "López", "M", Fecha.new(20, 7, 1992))
      expect(Persona.numero_instancias).to eq(3)
    end
  end

  # Pruebas para Comparable
  describe "Persona Comparable" do
    it "comprobando si persona es comparable" do
      expect(@persona).to be_a(Comparable)
    end

    it "compara dos personas correctamente usando <, <=, >, >=, between?, clamp" do
      persona1 = Persona.new(1, "Juan", "Pérez", "M", Fecha.new(10, 5, 1990))
      persona2 = Persona.new(1, "Juan", "Pérez", "M", Fecha.new(10, 5, 1990))
      persona3 = Persona.new(2, "Ana", "García", "F", Fecha.new(15, 6, 1985))
      expect(persona1 < persona3).to be true
      expect(persona1 <= persona2).to be true
      expect(persona1 > persona3).to be false
      expect(persona1 >= persona2).to be true
      expect(persona1.between?(persona2, persona3)).to be true
      expect(persona1.clamp(persona2, persona3)).to eq(persona1)
    end
  end

  # Pruebas para Enumerable
  describe "Persona Enumerable" do 
    it "comprobando si persona es enumerable" do
      expect(@persona).to be_a(Enumerable)
    end
    
    it "comprueba que se pueda recorrer la instancia de Persona" do
      expect(@persona.map { |attr| attr }).to eq([1, "Juan Pérez", "M", Fecha.new(10, 5, 1990)])
    end

    it "comprueba que se pueda usar el metodo map con Persona" do
      expect(@persona.map { |attr| attr.class }).to eq([Integer, String, String, Fecha])
    end

    it "comprueba que se pueda usar el metodo select con Persona" do
      expect(@persona.select { |attr| attr.is_a?(String) }).to eq(["Juan Pérez", "M"])
    end

    it "comprueba que se pueda usar el metodo find con Persona" do
      expect(@persona.find { |attr| attr == "Juan Pérez" }).to eq("Juan Pérez")
    end

    it "comprueba que se pueda usar el metodo all? con Persona" do
      expect(@persona.all? { |attr| !attr.nil? }).to be true
    end
  end
end