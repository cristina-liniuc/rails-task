class Account < ApplicationRecord
  has_many :transactions, 'primary_key': 'account_id', 'foreign_key': 'account_id'
end
