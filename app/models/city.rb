class City < ActiveRecord::Base
  attr_accessible :name
  has_many :groups
  validates :name, :uniqueness => true
end
