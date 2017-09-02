class CreateListing < ActiveRecord::Migration[5.0]
  def change
    create_table :listings do |t|
      t.string :pid
      t.string :url
      
      t.timestamps
    end
    
    add_index :listings, :pid
  end
end
