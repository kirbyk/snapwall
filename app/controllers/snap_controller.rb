class SnapController < ApplicationController

  def index
    if params.has_key? :not
      not_ids = params[:not].split(",")
      query = Snap.where(
        'created_at > ? AND id NOT IN (?)', 
        THRESHOLD.ago, 
        not_ids
      )
    else
      query = Snap.where('created_at > ?', THRESHOLD.ago)
    end

    fake = FakeSnap.new("http://lorempixel.com/540/960/", 10)
    
    if request.format == :html
      if query.empty?
        @snaps = [fake]*8
      else
        @snaps = query.order("RANDOM()").limit(8).to_a + [fake] * (8 - query.limit(8).size)
      end
    else
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
end
