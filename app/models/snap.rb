class Snap < ActiveRecord::Base
  has_attached_file :image
  attr_accessor :image_bytes, :image_name, :image_content_type
  before_validation :create_image

  BESTOF_THRESHOLD = 30

  scope :best_of, -> { where("likes > ?", BESTOF_THRESHOLD) }

  def create_image
    self.image = ByteImage.new(
      image_bytes,
      image_name,
      image_content_type
    ).image
  end

  #TODO UNstub
  def likes
    return rand(30..60)
  end


end
