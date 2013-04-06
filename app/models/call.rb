class Call < ActiveRecord::Base
  attr_accessible :end, :frequency, :start, :group_id, :audio_id
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
  has_one :audio

  def group_name
    return group ? group.name : "UNKNOWN"
  end

  def full_group_name
    return group ? group.full_name : "UNKNOWN"
  end
end
