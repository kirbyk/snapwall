class BlacklistImageGenerator
  def generate
    canvas = Magick::ImageList.new.from_blob(open(File.join(Rails.root, "message.jpg")) { |f| f.read } )
    gc = Magick::Draw.new
    gc.stroke 'black'
    gc.stroke_width 2
    gc.font_weight 600
    gc.fill 'white'
    gc.pointsize 50
    gc.text(20, 240, "You've been banned!".center(5))
    gc.text(30, 300, "Stop it!".center(30))
    gc.draw(canvas)
    canvas.format = 'jpeg'
    canvas.to_blob
  end
end
