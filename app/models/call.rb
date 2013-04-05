class Call < ActiveRecord::Base
  attr_accessible :end, :frequency, :start, :group_id
  belongs_to :group
  validates :start, :presence => true
  validates :end, :presence => true
  validates :end, :date => { :after => :start }
  validates :frequency, :presence => true
  validates :group_id,
            :numericality => { :only_integer => true,
                               :greater_than_or_equal_to => 0x0,
                               :less_than_or_equal_to => 0xFFFF },
                       :presence => true
  validates_associated :group

  def group_name
    return group ? group.name : "UNKNOWN"
  end
end
