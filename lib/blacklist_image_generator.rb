class BlacklistImageGenerator
  def generate
    canvas = Magick::ImageList.new.from_blob(open(File.join(Rails.root, "message.jpg")) { |f| f.read } )
    gc = Magick::Draw.new
    gc.stroke 'white'
    gc.fill 'white'
    gc.pointsize 50
    gc.text(30, 240, "You've been banned!".center(14))
    gc.text(30, 300, "Stop it!".center(30))
    gc.draw(canvas)
    canvas.format = 'jpeg'
    canvas.to_blob
  end
end
