class Connection < ApplicationRecord
  has_many :accounts, 'primary_key': 'connection_id', 'foreign_key': 'connection_id'
end
