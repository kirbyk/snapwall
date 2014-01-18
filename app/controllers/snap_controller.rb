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
    snap = Snap.find_by!(params[:id])
    snap.likes += 1
    snap.save
    render nothing: true
  end

  def flag
    snap = Snap.find_by!(params[:id])
    snap.flags += 1
    snap.save
    if snap.flags == 10
      Blacklist.create(username: snap.username)
      Delayed::Job.enqueue BlacklistMessageJob.new(snap.username)
    end
    render nothing: true
  end
end
