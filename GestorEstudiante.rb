require 'csv'
require 'sinatra'
require 'json'
ARCHIVO_ESTUDIANTES = 'estudiantes.csv'
class GestorEstudiante
  attr_accessor :estudiantes

    def initialize(data)
        @estudiantes = data
    end

    def write_data_to_csv
        CSV.open(ARCHIVO_ESTUDIANTES, 'w') do |csv|
          csv << ['nombre', 'correo', 'nombre_usuario', 'contrasena']
          estudiantes.each { |row| csv << row.values }
        end
    end

    def read_data_from_csv
        data = []
        CSV.foreach(ARCHIVO_ESTUDIANTES, headers: true) do |row|
          data << row.to_h
        end
        @estudiantes = data
    end

end

gestor = GestorEstudiante.new([])

#Meiyin Chang
get '/api/users' do
    content_type :json
    gestor.read_data_from_csv
    gestor.estudiantes.to_json
end

post '/api/users' do
    request_body = JSON.parse(request.body.read)
    gestor.read_data_from_csv
    gestor.estudiantes.each_with_index do |usuario, index|
        if usuario['nombre_usuario'] == request_body['nombre_usuario']
          return status 400
        end
      end
    gestor.estudiantes << request_body
    gestor.write_data_to_csv()
    status 201
    request_body.to_json
end

#Diego Martinez
put '/api/users/:nombre' do
  nombreUser = params['nombre']
  request_body = JSON.parse(request.body.read)
  gestor.read_data_from_csv
  gestor.estudiantes.each_with_index do |userName, index|
      if userName['nombre'] == nombreUser
        gestor.estudiantes[index] = request_body
      end
  end
  gestor.write_data_to_csv()
  status 204
  {"UPDATED" => nombreUser}.to_json
end


delete '/api/users/:nombre' do
  nombreUser = params['nombre']
  gestor.read_data_from_csv
  gestor.estudiantes.reject! { |user| user['nombre'] == nombreUser }
  gestor.write_data_to_csv
  status 204
end