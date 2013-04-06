class AddAudioToCall < ActiveRecord::Migration
  def change
    add_column :calls, :audio_id, :integer
  end
end
