class Audio < ActiveRecord::Base
  attr_accessible :data
  belongs_to :call
  has_attached_file :data,
                    :path => ":rails_root/public/system/:class/:attachment/:recorded_at_partition/:style/:filename"
  # TODO: styles for mp3/vorbis/imbe/etc
  validates :data, :attachment_presence => true

  def recorded_at
    call.start
  end
end
