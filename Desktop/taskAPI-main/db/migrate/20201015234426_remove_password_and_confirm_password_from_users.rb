class RemovePasswordAndConfirmPasswordFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :password, :string
    remove_column :users, :confirmpassword, :string
  end
end
