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

    fake = FakeSnap.new("http://lorempixel.com/cymbaler/540/960/", 10)
    
    if request.format == :html
      if query.empty?
        @snaps = [fake]*8
      else
        @snaps = query.limit(8).to_a + [fake] * (8 - query.limit(8).size)
      end
    else
      if query.empty?
        @snap = fake
      else
        @snap = query.first
      end
    end
  end
end
