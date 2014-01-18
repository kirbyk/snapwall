class BlacklistImageGenerator
  def generate
    canvas = Magick::Image.new(540, 960) { self.background_color = 'gray' }
    gc = Magick::Draw.new
    gc.pointsize 50
    gc.text(30, 340, "You've been banned!".center(14))
    gc.text(30, 400, "Stop it!".center(30))
    gc.draw(canvas)
    canvas.format = 'jpeg'
    canvas.to_blob
  end
end
