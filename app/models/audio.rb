class Audio < ActiveRecord::Base
  attr_accessible :data
  belongs_to :call
  has_attached_file :data # TODO: styles for mp3/vorbis/imbe/etc
  validates :data, :attachment_presence => true
end
