class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :work_id
      t.integer :sex
      t.integer :xplace
      t.integer :yplace
      t.integer :wsize
      t.integer :hsize

      t.timestamps
    end
  end
end
