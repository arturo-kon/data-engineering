class Merchant < ActiveRecord::Base
  has_many :orders
end