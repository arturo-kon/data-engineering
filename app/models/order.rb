class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :merchant
  belongs_to :product
end