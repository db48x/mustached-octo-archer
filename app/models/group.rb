class Group < ActiveRecord::Base
  attr_accessible :name
  belongs_to :city
  has_many :calls
  validates :name, :uniqueness => { :scope => :city_id }
  validates_associated :city
  validates :city_id, :presence => true
end
