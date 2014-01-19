class ImageGenerator < Struct.new(:num)
  def generate
    canvas = Magick::ImageList.new.from_blob(open(File.join(Rails.root, "message.jpg")) { |f| f.read } )
    gc = Magick::Draw.new
    gc.stroke 'black'
    gc.stroke_width 2
    gc.font_weight 600
    gc.fill 'white'
    gc.pointsize 50
    gc.text(30, 240, "You've received".center(22))
    gc.text(30, 300, "#{num} likes".center(27))
    gc.text(30, 360, "on your snap, which".center(20))
    gc.text(26, 420, "means it is posted to".center(5))
    gc.text(30, 480, "SnapWall Best Of!".center(22))
    gc.draw(canvas)
    canvas.format = 'jpeg'
    canvas.to_blob
  end
end
