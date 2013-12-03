class AddFotoToUser < ActiveRecord::Migration
  def up
  	add_attachment :alumnos, :foto
  end
  def down
  	remove_attachment :alumnos, :foto
  end 
end
