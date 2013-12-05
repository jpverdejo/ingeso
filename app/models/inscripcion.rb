class Inscripcion < ActiveRecord::Base
	belongs_to :sala
	belongs_to :prueba
	belongs_to :alumno
end
