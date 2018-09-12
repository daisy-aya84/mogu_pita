class Droptable < ActiveRecord::Migration[5.2]
  def change
    drop_table :works
  end
end
