# frozen_string_literal: true

require "spec_helper"
require_relative "../lib/triaje/nivel"

# Pruebas para la clase nivel
RSpec.describe Nivel do
  # Prueba para el método initialize de la clase nivel
  it "inicializa con los correctos atributos" do
    nivel = Nivel.new(1, "Rojo", "Emergencia", 7)
    expect(nivel.nivel).to eq(1)
    expect(nivel.color).to eq("Rojo")
    expect(nivel.categoria).to eq("Emergencia")
    expect(nivel.tiempo).to eq(7)
  end

  # Prueba para el método to_s de la clase nivel
  it "devuelve la cadena correcta de la clase nivel" do
    nivel = Nivel.new(1, "Rojo", "Emergencia", 7)
    expect(nivel.to_s).to eq("Nivel: 1, Color: Rojo, Categoría: Emergencia, Tiempo: 7 minutos")
  end

  # Prueba para verificar la herencia de la clase nivel
  it "Verificar la herencia de clase nivel" do
    expect(Nivel < Object).to be true
  end

  # Prueba para verificar que una instancia de nivel es una instancia de Object
  it "La instancia de instancia de nivel" do
    nivel = Nivel.new(1, "Rojo", "Emergencia", 7)
    expect(nivel).to be_an_instance_of(Nivel)
    expect(nivel).to be_a(Object)
  end

  # Prueba para el método de comparación ==
  it "compara dos niveles correctamente usando ==" do
    nivel1 = Nivel.new(1, "Rojo", "Emergencia", 7)
    nivel2 = Nivel.new(1, "Rojo", "Emergencia", 7)
    nivel3 = Nivel.new(2, "Amarillo", "Urgencia", 10)
    expect(nivel1 == nivel2).to be true
    expect(nivel1 == nivel3).to be false
  end

  # Prueba para el método de comparación <=>
  it "compara dos niveles correctamente usando <=>" do
    nivel1 = Nivel.new(1, "Rojo", "Emergencia", 7)
    nivel2 = Nivel.new(1, "Rojo", "Emergencia", 7)
    nivel3 = Nivel.new(2, "Amarillo", "Urgencia", 10)
    nivel4 = Nivel.new(3, "Verde", "No Urgente", 60)
    expect(nivel1 <=> nivel2).to eq(0)
    expect(nivel1 <=> nivel3).to eq(-1)
    expect(nivel3 <=> nivel4).to eq(-1)
  end

  # Prueba de herencia para comprobar si un nivel es comparable
  it "comprobando si un nivel es comparable" do
    nivel = Nivel.new(1, "Rojo", "Emergencia", 7)
    expect(nivel).to be_a(Comparable)
  end

   it 'verifica que dos instancias de Nivel con los mismos atributos sean iguales' do
    nivel1 = Nivel.new(1, "Rojo", "Emergencia", 7)
    nivel2 = Nivel.new(1, "Rojo", "Emergencia", 7)
    expect(nivel1).to eq(nivel2)
  end

  # Prueba para el método de comparación <, <=, >, >=, between?, clamp de la clase nivel
  it "compara dos niveles correctamente usando <, <=, >, >=, between?, clamp" do
    nivel1 = Nivel.new(1, "Rojo", "Emergencia", 7)
    nivel2 = Nivel.new(1, "Rojo", "Emergencia", 7)
    nivel3 = Nivel.new(2, "Amarillo", "Urgencia", 10)
    nivel4 = Nivel.new(3, "Verde", "No Urgente", 60)
    expect(nivel1 < nivel3).to be true
    expect(nivel1 <= nivel2).to be true
    expect(nivel3 > nivel1).to be true
    expect(nivel3 >= nivel2).to be true
    expect(nivel1.between?(nivel2, nivel3)).to be true
    expect(nivel1.clamp(nivel2, nivel3)).to eq(nivel1)
  end

  # Prueba de herecia para comprobar si un nivel es enumerable
  it "comprobando si un nivel es enumerable" do
    nivel = Nivel.new(1, "Rojo", "Emergencia", 7)
    expect(nivel).to be_a(Enumerable)
  end
  
  # Prueba para el método collect de Enumerable en la clase nivel
  it "mapea correctamente los atributos usando collect" do
    nivel = Nivel.new(1, "Rojo", "Emergencia", 7)
    expect(nivel.collect { |attr| attr.to_s + "x" }).to eq(["1x", "Rojox", "Emergenciax", "7x"])
  end

  # Prueba para el método detect de Enumerable en la clase nivel
  it "detecta correctamente el primer atributo que cumple la condición usando detect" do
    nivel = Nivel.new(1, "Rojo", "Emergencia", 7)
    expect(nivel.detect { |attr| attr.is_a?(Integer) }).to eq(1)
  end

  # Prueba para el método select de Enumerable en la clase nivel
  it "selecciona correctamente los atributos que cumplen la condición usando select" do
    nivel = Nivel.new(1, "Rojo", "Emergencia", 7)
    expect(nivel.select { |attr| attr.is_a?(String) }).to eq(["Rojo", "Emergencia"])
  end

  # Prueba para el método any? de Enumerable en la clase nivel
  it "devuelve true si algún atributo cumple la condición usando any?" do
    nivel = Nivel.new(1, "Rojo", "Emergencia", 7)
    expect(nivel.any? { |attr| attr == "Rojo" }).to be true
  end

  # Prueba para el método all? de Enumerable en la clase nivel
  it "devuelve true si todos los atributos cumplen la condición usando all?" do
    nivel = Nivel.new(1, "Rojo", "Emergencia", 7)
    expect(nivel.all? { |attr| attr.is_a?(Object) }).to be true
  end
end