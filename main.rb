require 'sinatra'
require './GestorEstudiante'

gestor_estudiantes = GestorEstudiante.new([])

#Meiyin

get '/' do
    content_type :html
    gestor_estudiantes.read_data_from_csv
    estudiantes = gestor_estudiantes.estudiantes.map { |estudiante| "#{estudiante['nombre']}, #{estudiante['correo']}, #{estudiante['nombre_usuario']}" }
    "<h1>Lista de Estudiantes:</h1><ul><li>#{estudiantes.join('</li><li>')}</li></ul>"
end

#Diego Martinez
