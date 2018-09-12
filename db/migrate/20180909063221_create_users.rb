class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :image
      t.string :cut_img
      t.string :final_img
      t.integer :f_id

      t.timestamps
    end
  end
end
