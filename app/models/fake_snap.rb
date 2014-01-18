class FakeSnap

  class FakeImage
    attr_reader :url
    def initialize(url)
      @url = url
    end
  end

  attr_reader :image, :duration, :id

  def initialize(url, duration)
    @image, @duration, @id = FakeImage.new(url), duration, 0
  end
end
