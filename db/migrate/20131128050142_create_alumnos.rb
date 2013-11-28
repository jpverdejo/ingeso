class CreateAlumnos < ActiveRecord::Migration
  def change
    create_table :alumnos do |t|
      t.string :rut
      t.string :nombre
      t.integer :carrera_id
      t.integer :ingreso_ano
      t.integer :ingreso_semestre
      t.string :grupo
      t.string :seccion
      t.boolean :foto

      t.timestamps
    end
  end
end
