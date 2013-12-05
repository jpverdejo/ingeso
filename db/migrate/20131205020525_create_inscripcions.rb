class CreateInscripcions < ActiveRecord::Migration
  def change
    create_table :inscripcions do |t|
      t.belongs_to :alumno
      t.belongs_to :prueba
      t.belongs_to :sala

      t.boolean :presente

      t.timestamps
    end
  end
end
