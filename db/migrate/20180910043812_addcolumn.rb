class Addcolumn < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :op_id, :integer, after: :final_img
  end
end
