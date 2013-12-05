class Sala < ActiveRecord::Base
	belongs_to :prueba
	
	has_many :inscripcions
	has_many :alumnos, :through => :inscripcions
end
