class Call < ActiveRecord::Base
  attr_accessible :end, :frequency, :start
  belongs_to :group
  validates :start, :presence => true
  validates :end, :presence => true
  validates :frequency, :presence => true
  validates_associated :group
  validates :group_id, :presence => true
end
