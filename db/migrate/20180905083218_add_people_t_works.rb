class AddPeopleTWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :people, :integer
  end
end
