class SnapController < ApplicationController

  def index
    threshold = 30.minutes


    if params.has_key? :not
      not_ids = params[:not].split(",")
      @snap = Snap.where(
        'created_at > ? AND id NOT IN (?)', 
        threshold.ago, 
        not_ids
      ).first
    else
      @snap = Snap.where('created_at > ?', threshold.ago).first
    end

    @snap = FakeSnap.new("http://lorempixel.com/cymbaler/540/960/", 10) if @snap.nil?
    cleanup(threshold)
  end


  private 
  def cleanup threshold
    # won't work. will send duplicates
    old_snaps = Snap.best_of.where('created_at < ?', threshold.ago)
    old_snaps.each do |snap|
      if snap.best_of?
        send_best_of snap
      end
    end
  end

  def send_best_of snap
    canvas = Magick::Image.new(960, 540){self.background_color = 'white'}
    gc = Magick::Draw.new
    gc.pointsize(50)
    gc.text(30,70, "You made Best Of with #{snap.likes}!".center(14))

    gc.draw(canvas)
    
    str = StringIO.open(canvas.to_blob)
  end
end
