# spec/titular_spec.rb

require 'rspec'
require_relative '../lib/triaje/titular'
require_relative '../lib/triaje/paciente'
require_relative '../lib/triaje/fecha'
require_relative '../lib/triaje/nivel'

RSpec.describe Titular do
  before(:each) do
    fecha_nacimiento = Fecha.new(10, 5, 1980)

    # Crear pacientes
    @paciente_1 = Paciente.new(1, "Juan", "Pérez", "M", fecha_nacimiento, Triaje::NIVEL_II, ["grave"])
    @paciente_2 = Paciente.new(2, "Ana", "García", "F", fecha_nacimiento, Triaje::NIVEL_III, ["leve"])

    # Crear un médico titular con un máximo de 2 pacientes
    @medico_titular = Titular.new(1, "Carlos", "Gomez", "M", fecha_nacimiento, "general", [@paciente_1], 2)
  end

  describe '#carga_maxima_alcanzada?' do
    it 'verifica que el médico titular no haya alcanzado la carga máxima de pacientes' do
      expect(@medico_titular.carga_maxima_alcanzada?).to eq(false)
    end

    it 'verifica que el médico titular haya alcanzado la carga máxima de pacientes' do
      @medico_titular.asignar_paciente(@paciente_2)
      expect(@medico_titular.carga_maxima_alcanzada?).to eq(true)
    end
  end

  describe '#to_s' do
    it 'verifica la conversión a cadena para el médico titular' do
      expected = "Carlos Gomez (Especialidad: general), Número de pacientes: 1, Carga máxima de pacientes: 2, Carga alcanzada: No"
      expect(@medico_titular.to_s).to eq(expected)
    end
  end

  describe '#asignar_paciente' do
    it 'verifica que se lanza un error si se asignan más pacientes de los permitidos' do
      @medico_titular.asignar_paciente(@paciente_2) # Asignar segundo paciente
      expect { @medico_titular.asignar_paciente(Paciente.new(3, "Lucia", "Martínez", "F", Fecha.new(15, 3, 1995), Triaje::NIVEL_IV, ["leve"])) }.to raise_error(ArgumentError, "El número máximo de pacientes ha sido alcanzado.")
    end
  end

  describe '#especialidad' do
    it 'verifica que la especialidad del médico titular sea válida' do
      expect { Titular.new(1, "Carlos", "Gomez", "M", Fecha.new(10, 5, 1980), "cirugía", [], 2) }.to raise_error(ArgumentError, "Especialidad inválida. Debe ser una de: general, geriatría, pediatría")
    end
  end

  describe 'herencia de Medico' do
    it 'verifica que la clase de @medico_titular sea Titular' do
      expect(@medico_titular.class).to eq(Titular)
    end

    it 'verifica que la superclase de Titular sea Medico' do
      expect(@medico_titular.class.superclass).to eq(Medico)
    end
  end

  describe 'visibilidad privada' do
    it 'comprueba que el acceso directo a nombre y apellido provoque un error' do
      expect { @medico_titular.nombre }.to raise_error(NoMethodError)
      expect { @medico_titular.apellido }.to raise_error(NoMethodError)
    end
  end

  describe 'visibilidad protegida' do
    it 'comprueba que el acceso directo a fecha_nacimiento desde una instancia externa provoque un error' do
      expect { @medico_titular.fecha_nacimiento }.to raise_error(NoMethodError)
    end
  end

  describe 'visibilidad pública' do
    it 'verifica que max_pacientes sea accesible públicamente' do
      expect(@medico_titular.max_pacientes).to eq(2)
    end
  end

  describe 'Titular Enumerable' do
    it 'comprobando si titular es enumerable' do
      expect(@medico_titular).to be_a(Enumerable)
    end

    it 'verifica que el método each itera sobre los atributos correctamente' do
      attributes = []
      @medico_titular.each { |attr| attributes << attr }
      expect(attributes).to eq([1, "Carlos Gomez", "M", Fecha.new(10, 5, 1980), "general", 2])
    end

    it 'verifica que el método map funciona correctamente' do
      mapped = @medico_titular.map { |attr| attr.to_s }
      expect(mapped).to eq(["1", "Carlos Gomez", "M", "10/5/1980", "general", "2"])
    end

    it 'verifica que el método select funciona correctamente' do
      selected = @medico_titular.select { |attr| attr.is_a?(String) }
      expect(selected).to eq(["Carlos Gomez", "M", "general"])
    end

    it 'verifica que el método find funciona correctamente' do
      found = @medico_titular.find { |attr| attr == "general" }
      expect(found).to eq("general")
    end

    it 'verifica que el método all? funciona correctamente' do
      all_strings = @medico_titular.all? { |attr| attr.is_a?(String) }
      expect(all_strings).to eq(false)
    end
  end
end