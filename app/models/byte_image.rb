class ByteImage
  attr_reader :image

  def initialize(data, original_filename, content_type)
    @original_filename = original_filename
    @content_type = content_type
    @image = generate_image(data, original_filename, content_type)
  end

  private

  def generate_image(data, original_filename, content_type)
    io = StringIO.new(data)
    io.class.class_eval { attr_accessor :original_filename, :content_type }
    io.original_filename = original_filename
    io.content_type = content_type
    io
  end
end
