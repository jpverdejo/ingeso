class CreateSalas < ActiveRecord::Migration
  def change
    create_table :salas do |t|
      t.string :nombre
      t.integer :capacidad
      t.belongs_to :prueba

      t.timestamps
    end
  end
end
