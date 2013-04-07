class PagesController < ApplicationController
  def player
    @calls = Call.where("start >= ? AND audio_id IS NOT NULL", Time.now - 1.day)
  end

  def about
  end
end
