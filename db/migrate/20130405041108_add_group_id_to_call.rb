class AddGroupIdToCall < ActiveRecord::Migration
  def change
    add_column :calls, :group_id, :integer
  end
end
