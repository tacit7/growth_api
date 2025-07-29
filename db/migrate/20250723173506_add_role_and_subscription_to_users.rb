class AddRoleAndSubscriptionToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :integer
    add_column :users, :subscription_type, :integer
  end
end
