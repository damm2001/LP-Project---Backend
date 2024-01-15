require 'csv'
require 'sinatra'
require 'json'
ARCHIVO = 'libros.csv'

class GestorLibros
  attr_accessor :libros

    def initialize(data)
      @libros = data
    end
  
    def write_data_to_csv()      
      CSV.open(ARCHIVO, 'w') do |csv|
          csv << ["titulo", "autor", "edicion", "disponibilidad"]
          libros.each {|row| csv << row.values}
        end
    end
  
    def read_data_from_csv
      data = []
      CSV.foreach(ARCHIVO, headers: true) do |row|
        data << row.to_h
      end
      @libros = data
      end
end
# Habilitar CORS para todas las libros

gestor = GestorLibros.new([])
  
  get '/api/libros' do
    content_type :json
    gestor.read_data_from_csv
    gestor.libros.to_json
end
  
post '/api/libros' do
    request_body = JSON.parse(request.body.read)
    gestor.read_data_from_csv
    gestor.libros << request_body
    gestor.write_data_to_csv()
    status 201
    request_body.to_json
end
