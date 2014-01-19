require "base64"

class SnapController < ApplicationController

  def index
    if params[:not] && !params[:not].empty?
      not_ids = params[:not].split(",")
      query = Snap.where(
        'created_at > ? AND id NOT IN (?)', 
        THRESHOLD.ago, 
        not_ids
      )
    else
      query = Snap.where(
        'created_at > ?', 
        THRESHOLD.ago
      )
    end

    fake = FakeSnap.new("http://dummyimage.com/540x960/000/fff", 10)
    
    if request.format == :json
      if query.empty?
        @snap = fake
      else
        @snap = query.order("RANDOM()").first
      end
    end
  end

  def like
    snap = Snap.find(params[:id])
    snap.likes += 1
    snap.save
    render nothing: true
  end

  def flag
    snap = Snap.find(params[:id])
    snap.flags += 1
    snap.save
    if snap.flags >= 5
      snap.destroy
      Blacklist.create(username: snap.username)
      Delayed::Job.enqueue BlacklistMessageJob.new(snap.username)
    end
    render nothing: true
  end
  
  def create
    p = create_params

    unless Snap.find_by(snap_id: p[:snap_id])

      if Blacklist.find_by(username: p[:username])
        puts "Going to send blacklist message"
        send_blacklist_message(p[:username])
        head :ok
        return
      end

      s = Snap.new({
        username: p[:username],
        duration: p[:duration],
        snap_id: p[:snap_id],
      })
      s.image_bytes = Base64.decode64(p[:base64])
      s.image_name = "#{p[:snap_id]}.jpg"
      s.image_content_type = "image/jpeg"
      s.save!
    end
    head :ok
  end

  private

  def create_params
    params.permit(:username, :duration, :snap_id, :base64)
  end
  
  def send_blacklist_message(username)
    Delayed::Job.enqueue BlacklistMessageJob.new(username)
  end

end
