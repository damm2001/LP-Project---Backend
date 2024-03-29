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
          csv << ["titulo", "autor", "edicion", "disponibilidad","valoracion"]
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

#Irving Macías
gestor = GestorLibros.new([])

  get '/api/books' do
    content_type :json
    gestor.read_data_from_csv
    gestor.libros.to_json
end

post '/api/books' do
    request_body = JSON.parse(request.body.read)
    gestor.read_data_from_csv
    gestor.libros << request_body
    gestor.write_data_to_csv()
    status 201
    request_body.to_json
end

#Diego Martinez
put '/api/books/:titulo' do
  nombreRuta = params['titulo']
  request_body = JSON.parse(request.body.read)
  gestor.read_data_from_csv
  gestor.libros.each_with_index do |ruta, index|
    if ruta['titulo'] == nombreRuta
      gestor.libros[index] = request_body
    end
  end
  gestor.write_data_to_csv()
  status 200
  {"UPDATED" => nombreRuta}.to_json
end

delete '/api/books/:titulo' do
    nombreRuta = params['titulo']
    gestor.read_data_from_csv
    gestor.libros.each_with_index do |ruta, index|
      if ruta['titulo'] == nombreRuta
        gestor.libros.delete_at(index)
      end
    end
    gestor.write_data_to_csv()
    status 200
    {"DELETED" => nombreRuta}.to_json
end

#Meiyin Chang
# Ruta para buscar libros por título
get '/api/books/buscar/titulo/:titulo' do
  titulo = params['titulo']
  gestor.read_data_from_csv
  resultados = gestor.libros.select { |libro| libro['titulo'].include?(titulo) }
  resultados.to_json
end


#Irving Macías
# Ruta para buscar libros por autor
get '/api/books/buscar/autor/:autor' do
  autor = params['autor']
  gestor.read_data_from_csv
  resultados = gestor.libros.select { |libro| libro['autor'].include?(autor) }
  resultados.to_json
end

# Ruta para buscar libros por título o autor
get '/api/books/buscar' do
  termino = params['termino'].downcase
  gestor.read_data_from_csv
  resultados = gestor.libros.select do |libro|
    libro['titulo'].downcase.include?(termino) || libro['autor'].downcase.include?(termino)
  end
  resultados.to_json
end

# Ruta para buscar libros con disponibilidad true
get '/api/books/disponibilidad/true' do
  gestor.read_data_from_csv
  resultados = gestor.libros.select { |libro| libro['disponibilidad'] == "true" }
  resultados.to_json
end
