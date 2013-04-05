class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.timestamp :start
      t.timestamp :end
      t.string :frequency

      t.timestamps
    end
  end
end
