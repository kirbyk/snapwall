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
  end
end
