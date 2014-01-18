class Snap < ActiveRecord::Base
  has_attached_file :image
  attr_accessor :image_bytes, :image_name, :image_content_type
  before_validation :create_image, if: :has_image?

  scope :best, -> { where("likes > ?", BESTOF_THRESHOLD)  }

  def has_image?
    image_bytes
  end

  def create_image
    self.image = ByteImage.new(
      image_bytes,
      image_name,
      image_content_type
    ).image
  end
end
