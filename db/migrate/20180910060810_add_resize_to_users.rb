class AddResizeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :resized_img, :string , after: :final_img
  end
end
