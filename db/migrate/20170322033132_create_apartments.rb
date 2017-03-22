class CreateApartments < ActiveRecord::Migration[5.0]
  def change
    create_table :apartments do |t|
      t.string :number
      t.string :floorplan
      t.string :price_range
      t.string :url

      t.timestamps
    end

    add_index :apartments, :number
  end
end
