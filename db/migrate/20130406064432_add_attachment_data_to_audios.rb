class AddAttachmentDataToAudios < ActiveRecord::Migration
  def self.up
    change_table :audios do |t|
      t.attachment :data
    end
  end

  def self.down
    drop_attached_file :audios, :data
  end
end
