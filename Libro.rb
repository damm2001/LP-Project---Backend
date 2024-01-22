class Libro
  attr_accessor :titulo, :autor, :edicion, :disponibilidad, :valoracion

  def initialize(titulo, autor, edicion, disponibilidad, valoracion)
    @titulo = titulo
    @autor = autor
    @edicion = edicion
    @disponibilidad = disponibilidad
    @valoracion = valoracion
  end
end
