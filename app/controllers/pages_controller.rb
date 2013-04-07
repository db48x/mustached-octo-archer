class PagesController < ApplicationController
  def player
    @calls = Call.where("audio_id IS NOT NULL").order("start ASC").limit(50)
  end

  def about
  end
end
