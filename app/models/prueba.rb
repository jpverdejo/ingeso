class Prueba < ActiveRecord::Base
	has_many :salas
	
	has_many :inscripcions
	has_many :alumnos, :through => :inscripcions
end
