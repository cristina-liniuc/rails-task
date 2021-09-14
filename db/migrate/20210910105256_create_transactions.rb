class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.integer :transaction_id
      t.string :mode
      t.string :status
      t.date :made_on
      t.float :amount
      t.string :currency_code
      t.string :description
      t.float :origiinal_amount
      t.string :original_currency_code

      t.timestamps
    end
  end
end
