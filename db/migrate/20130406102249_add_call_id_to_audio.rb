class AddCallIdToAudio < ActiveRecord::Migration
  def change
    add_column :audios, :call_id, :integer
  end
end
