class PagesController < ApplicationController
  def player
    calls = Call.where("audio_id IS NOT NULL").order("start ASC").limit(50).map do |call|
      { :id => call.id,
        :start => call.start,
        :end => call.end,
        :frequency => call.frequency,
        :group_full_name => call.group.full_name,
        :group_name => call.group.name }
    end
    @calls = ActiveSupport::JSON.encode(calls)
  end

  def about
  end
end
