require 'csv'
require 'sinatra'
require 'json'

ARCHIVO_estudianteS_RUTA = 'estudianteLibros.csv'

class GestorEstudianteLibros
  attr_accessor : estudianteLibros

    def initialize(data)
        @estudianteLibros = data
    end
    def write_data_to_csv
        CSV.open(ARCHIVO_estudianteS_RUTA, 'w') do |csv|
          csv << ['estudiante', 'libro']
          estudianteLibros.each { |row| csv << row.values }
        end
    end
    def read_data_from_csv
        data = []
        CSV.foreach(ARCHIVO_estudianteS_RUTA, headers: true) do |row|
          data << row.to_h
        end
        @estudianteLibros = data
    end
end

gestor = GestorestudianteLibros.new([])

get '/api/estudiantes_libros' do
    content_type :json
    gestor.read_data_from_csv
    gestor.estudianteLibros.to_json
end
  
post '/api/estudiantes_libros' do
    request_body = JSON.parse(request.body.read)
    gestor.read_data_from_csv
    gestor.estudianteLibros.each_with_index do |userRoutePair, index|
        if userRoutePair['estudiante'] == request_body['estudiante'] && userRoutePair['libro'] == request_body['libro']
          return status 400
        end
      end
    gestor.estudianteLibros << request_body
    gestor.write_data_to_csv()
    status 201
    request_body.to_json
end

delete '/api/estudiantes_libros/:estudiante/:libro' do
    nombreLibro = params['libro']
    nombreEstudiante = params['estudiante']
    gestor.read_data_from_csv()
    index = gestor.estudianteLibros.find_index { |libro| libro['libro'] == nombreLibro && libro['estudiante'] == nombreEstudiante}
    gestor.estudianteLibros.delete_at(index.to_i)
    gestor.write_data_to_csv()
    status 204
end