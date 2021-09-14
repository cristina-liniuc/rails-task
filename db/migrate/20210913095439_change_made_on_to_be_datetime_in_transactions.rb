class ChangeMadeOnToBeDatetimeInTransactions < ActiveRecord::Migration[6.1]
  def change
    change_column :transactions, :made_on, :datetime
  end
end
