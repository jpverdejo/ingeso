class Alumno < ActiveRecord::Base
	has_many :inscripcions
	has_many :pruebas, :through => :inscripcions
	has_many :salas, :through => :inscripcions
	
	has_attached_file :foto, :styles => { :normal => "600x600>", :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
end
