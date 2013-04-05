class Group < ActiveRecord::Base
  attr_accessible :name, :city_id
  belongs_to :city
  has_many :calls
  validates :name, :uniqueness => { :scope => :city_id }
  validates_associated :city
  validates :city_id, :presence => true

  def full_name
    city ? "%s %s" % [city.name, name] : name
  end
end
