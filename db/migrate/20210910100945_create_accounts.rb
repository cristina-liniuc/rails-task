class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.integer :account_id
      t.string :name
      t.string :nature
      t.float :ballance
      t.string :curency_code
      t.integer :connection_id
      t.string :client_name

      t.timestamps
    end
  end
end
