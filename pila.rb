# pila.rb

# Inicializar la pila como una variable global
$pila = []

def crear_ra(valor_a_devolver, parametros, control, locales, temporales) 
  {
    valor_a_devolver: valor_a_devolver,
    parametros: parametros,
    control: control,
    locales: locales,
    temporales: temporales
  }
end

def push(registro)
  $pila.push(registro)
end

def pop()
  $pila.pop
end

def empty()
  $pila.empty?
end

def show()
  return "Empty stack" if $pila.empty?

  result = ""
  counter = 0

  $pila.reverse_each do |frame|
    counter += 1
    result += "{#{counter},"
    result += "#{frame[:parametros]},"
    result += "#{frame[:locales]},"
    result += "#{frame[:valor_a_devolver]}}\n"
  end

  return result
end

def sum(a, b)
  registro = crear_ra(nil, [a, b], {}, {}, {})
  push(registro)
  resultado = a + b
  $pila.last[:valor_a_devolver] = resultado
  x = $pila.last[:valor_a_devolver]
  pop()
  x
end

def fibonacci(n)
  registro = crear_ra(nil, [n], {}, {}, {})
  push(registro)

  if n == 0
    resultado = 0
  elsif n == 1
    resultado = 1
  else
    resultado = fibonacci(n - 1) + fibonacci(n - 2)
  end

  $pila.last[:valor_a_devolver] = resultado
  x = $pila.last[:valor_a_devolver]
  pop()
  x
end
