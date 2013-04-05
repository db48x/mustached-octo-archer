class RemoveUniqueIndexFromGroupsName < ActiveRecord::Migration
  def up
    remove_index :groups, :name => "index_groups_on_name"
  end

  def down
    add_index :groups, :name => "index_groups_on_name"
  end
end
