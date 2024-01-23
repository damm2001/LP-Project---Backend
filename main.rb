require 'sinatra'
require './GestorEstudiante'
require './GestorLibros'
require 'rack/cors'

use Rack::Cors do
  allow do
    origins '*'  # Cambia esto con el origen de tu aplicación Angular
    resource '/api/*', headers: :any, methods: [:get, :post, :put, :delete, :options]
  end
end
gestor_estudiantes = GestorEstudiante.new([])
gestor_libros = GestorLibros.new([])

#Meiyin Chang
get '/' do
    content_type :html
    gestor_estudiantes.read_data_from_csv
    estudiantes = gestor_estudiantes.estudiantes.map { |estudiante| "#{estudiante['nombre']}, #{estudiante['correo']}, #{estudiante['nombre_usuario']}" }
    "<h1>Lista de Estudiantes:</h1><ul><li>#{estudiantes.join('</li><li>')}</li></ul>"
end


=begin

#Irving Macias
get '/api/books' do
    content_type :html

    gestor_libros.read_data_from_csv
    libros = gestor_libros.libros.map do |libro|
      "<li>Titulo: #{libro['titulo']}, Autor: #{libro['autor']}, Edición: #{libro['edicion']}, Disponibilidad: #{libro['disponibilidad']}</li>"
    end

    "<h1>Lista de Libros:</h1><ul>#{libros.join}</ul>"
  end
=end

get '/api/books' do
  content_type :json
  gestor_libros.read_data_from_csv
  gestor_libros.libros.to_json
end
