# frozen_string_literal: true

require "spec_helper"
require_relative "../lib/triaje/hora"

# Pruebas para la clase Hora
RSpec.describe Hora do
  # Prueba para el método initialize de la clase Hora
  it "inicializa con los atributos correctos" do
    hora = Hora.new(12, 0, 0)
    expect(hora.hora).to eq(12)
    expect(hora.minuto).to eq(0)
    expect(hora.segundo).to eq(0)
  end

  # Prueba para el método to_s de la clase Hora
  it "Devuelve la string correcta" do
    hora = Hora.new(12, 0, 0)
    expect(hora.to_s).to eq("12:0:0")
  end

  # Prueba para verificar la herencia de la clase Hora
  it "Herencia clase Hora" do
    expect(Hora < Object).to be true
  end

  # Prueba para verificar que una instancia de Hora es una instancia de Object
  it "instancia del objeto de Hora" do
    hora = Hora.new(12, 0, 0)
    expect(hora).to be_an_instance_of(Hora)
    expect(hora).to be_a(Object)
  end

  # Prueba de herencia para comprobar si una hora es comparable
  it "comprobando si una hora es comparable" do
    hora = Hora.new(12, 0, 0)
    expect(hora).to be_a(Comparable)
  end

  it 'verifica que dos instancias de Hora con los mismos atributos sean iguales' do
    hora1 = Hora.new(12, 0, 0)
    hora2 = Hora.new(12, 0, 0)
    expect(hora1).to eq(hora2)
  end

  # Prueba para el método de comparación <, <=, >, >=, between?, clamp de la clase Hora
  it "compara dos horas correctamente usando <, <=, >, >=, between?, clamp" do
    hora1 = Hora.new(12, 0, 0)
    hora2 = Hora.new(12, 0, 0)
    hora3 = Hora.new(13, 0, 0)
    hora4 = Hora.new(11, 59, 59)
    expect(hora1 < hora3).to be true
    expect(hora1 <= hora2).to be true
    expect(hora1 > hora4).to be true
    expect(hora1 >= hora2).to be true
    expect(hora1.between?(hora4, hora3)).to be true
    expect(hora1.clamp(hora4, hora3)).to eq(hora1)
  end

  # Prueba de herecia para comprobar si una hora es enumerable
  it "comprobando si una hora es enumerable" do
    hora = Hora.new(12, 0, 0)
    expect(hora).to be_a(Enumerable)
  end

  # Prueba para el método collect de Enumerable en la clase Hora
  it "mapea correctamente los atributos usando collect" do
    hora = Hora.new(12, 0, 0)
    expect(hora.collect { |attr| attr.to_s + "x" }).to eq(["12x", "0x", "0x"])
  end

  # Prueba para el método detect de Enumerable en la clase Hora
  it "detecta correctamente el primer atributo que cumple la condición usando detect" do
    hora = Hora.new(12, 0, 0)
    expect(hora.detect { |attr| attr.between?(1, 11) }).to be_nil
  end

  # Prueba para el método select de Enumerable en la clase Hora
  it "selecciona correctamente los atributos que cumplen la condición usando select" do
    hora = Hora.new(12, 0, 0)
    expect(hora.select { |attr| attr.between?(0, 12) }).to eq([12, 0, 0])
  end

  # Prueba para el método sort de Enumerable en la clase Hora
  it "ordena correctamente los atributos usando sort" do
    hora = Hora.new(12, 0, 0)
    expect(hora.sort).to eq([0, 0, 12])
  end

  # Prueba para el método max de Enumerable en la clase Hora
  it "encuentra correctamente el atributo máximo usando max" do
    hora = Hora.new(12, 0, 0)
    expect(hora.max).to eq(12)
  end
end