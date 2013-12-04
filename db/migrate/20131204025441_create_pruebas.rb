class CreatePruebas < ActiveRecord::Migration
  def change
    create_table :pruebas do |t|
      t.string :titulo
      t.datetime :fecha

      t.timestamps
    end
  end
end
