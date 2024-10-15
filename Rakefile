task :default => :tu

desc "Pruebas unitarias Figuras Geometricas"
task :tu do
  sh "ruby -I. test/test_pila.rb"
end

desc "Ejecutar solo las pruebas simples"
task :simple do
  sh "ruby -I. test/test_pila.rb -n /simple/"
end
