module Paperclip::Interpolations
  def recorded_at_partition attachment, style_name
    attachment.instance.recorded_at.strftime(fmt="%Y/%m/%d/%H")
  end
end
