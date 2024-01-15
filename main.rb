require 'sinatra'
require './GestorEstudiante'
require './GestorLibros'

gestor_estudiantes = GestorEstudiante.new([])
gestor_libros = GestorLibros.new([])
#Meiyin

get '/' do
    content_type :html
    gestor_estudiantes.read_data_from_csv
    estudiantes = gestor_estudiantes.estudiantes.map { |estudiante| "#{estudiante['nombre']}, #{estudiante['correo']}, #{estudiante['nombre_usuario']}" }
    "<h1>Lista de Estudiantes:</h1><ul><li>#{estudiantes.join('</li><li>')}</li></ul>"
end

#Diego Martinez
#Irving Macias
get '/api/libros' do
    content_type :html
  
    gestor_libros.read_data_from_csv
    libros = gestor_libros.libros.map do |libro|
      "<li>Titulo: #{libro['titulo']}, Autor: #{libro['autor']}, Edición: #{libro['edicion']}, Disponibilidad: #{libro['disponibilidad']}</li>"
    end
  
    "<h1>Lista de Libros:</h1><ul>#{libros.join}</ul>"
  end