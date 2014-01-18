class ImageGenerator < Struct.new(:text)
  def generate
    canvas = Magick::Image.new(540, 960) { self.background_color = 'gray' }
    gc = Magick::Draw.new
    gc.pointsize 50
    gc.text(30, 70, text.center(14))
    gc.draw(canvas)
    canvas.format = 'jpeg'
    canvas.to_blob
  end
end
