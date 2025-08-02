# frozen_string_literal: true

require "spec_helper"
require_relative "../lib/triaje/nivel"

# Pruebas para la clase Fecha
RSpec.describe Fecha do
  # Prueba para el método initialize de la clase Fecha
  it "inicializa con los correctos atributos" do
    fecha = Fecha.new(1, 1, 2023)
    expect(fecha.dia).to eq(1)
    expect(fecha.mes).to eq(1)
    expect(fecha.anio).to eq(2023)
  end

  # Prueba para el método to_s de la clase Fecha
  it "devuelve la string correcta" do
    fecha = Fecha.new(1, 1, 2023)
    expect(fecha.to_s).to eq("1/1/2023")
  end

  # Prueba para verificar la herencia de la clase Fecha
  it "Herencia clase fecha" do
    expect(Fecha < Object).to be true
  end

  # Prueba para verificar que una instancia de Fecha es una instancia de Object
  it "instancia de la clase Fecha" do
    fecha = Fecha.new(1, 1, 2023)
    expect(fecha).to be_an_instance_of(Fecha)
    expect(fecha).to be_a(Object)
  end

   # Prueba de herencia para comprobar si una fecha es comparable
  it "comprobando si una fecha es comparable" do
    fecha = Fecha.new(1, 1, 2023)
    expect(fecha).to be_a(Comparable)
  end

  it 'verifica que dos instancias de Fecha con los mismos atributos sean iguales' do
    fecha1 = Fecha.new(10, 5, 1980)
    fecha2 = Fecha.new(10, 5, 1980)
    expect(fecha1).to eq(fecha2)
  end
  
  # Prueba para el método de comparación <, <=, >, >=, between?, clamp de la clase Fecha
  it "compara dos fechas correctamente usando <, <=, >, >=, between?, clamp" do
    fecha1 = Fecha.new(1, 1, 2023)
    fecha2 = Fecha.new(1, 1, 2023)
    fecha3 = Fecha.new(2, 1, 2023)
    fecha4 = Fecha.new(31, 12, 2022)
    expect(fecha1 < fecha3).to be true
    expect(fecha1 <= fecha2).to be true
    expect(fecha1 > fecha4).to be true
    expect(fecha1 >= fecha2).to be true
    expect(fecha1.between?(fecha4, fecha3)).to be true
    expect(fecha1.clamp(fecha4, fecha3)).to eq(fecha1)
  
  end
  
  # Prueba de herecia para comprobar si una fecha es enumerable
  it "comprobando si una fecha es enumerable" do
    fecha = Fecha.new(1, 1, 2023)
    expect(fecha).to be_a(Enumerable)
  end

  # Prueba para el método collect de Enumerable en la clase Fecha
  it "mapea correctamente los atributos usando collect" do
    fecha = Fecha.new(1, 1, 2023)
    expect(fecha.collect { |attr| attr.to_s + "x" }).to eq(["1x", "1x", "2023x"])
  end
  
  # Prueba para el método detect de Enumerable en la clase Fecha
  it "detecta correctamente el primer atributo que cumple la condición usando detect" do
    fecha = Fecha.new(1, 1, 2023)
    expect(fecha.detect { |attr| attr.between?(2, 3) }).to be_nil
  end

  # Prueba para el método select de Enumerable en la clase Fecha
  it "selecciona correctamente los atributos que cumplen la condición usando select" do
    fecha = Fecha.new(1, 1, 2023)
    expect(fecha.select { |attr| attr.between?(1, 2023) }).to eq([1, 1, 2023])
  end

  # Prueba para el método sort de Enumerable en la clase Fecha
  it "ordena correctamente los atributos usando sort" do
    fecha = Fecha.new(1, 1, 2023)
    expect(fecha.sort).to eq([1, 1, 2023])
  end

  # Prueba para el método max de Enumerable en la clase Fecha
  it "encuentra correctamente el atributo máximo usando max" do
    fecha = Fecha.new(1, 1, 2023)
    expect(fecha.max).to eq(2023)
  end
end