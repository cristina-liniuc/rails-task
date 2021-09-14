class CreateConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :connections do |t|
      t.integer :customer_id
      t.integer :connection_id
      t.string :provider_code
      t.string :provider_name

      t.timestamps
    end
  end
end
