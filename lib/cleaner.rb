require File.join(Rails.root, "lib", "image_generator.rb")
require File.join(Rails.root, "lib", "pinterest_api.rb")

class Cleaner

  def initialize(user, pass, pin_user, pin_pass, pin_board)
    @user = user
    @pass = pass
    @pin_user = pin_user
    @pin_pass = pin_pass
    @pin_board = pin_board
  end

  def clean
    @client = Snapcat::Client.new(@user)
    @client.login(@pass)
    @pin_client = PinterestApi.new(@pin_user, @pin_pass)
    @pin_client.login
    snaps = Snap.best.where(
      "(sent_best_of = 'f' OR sent_best_of IS NULL) AND created_at < ?",
      THRESHOLD.ago
    )
    snaps.each do |snap|
      puts "Cleaning snap from #{snap.username}"
      image_data =  ImageGenerator.new(
        "Your snap has made Best Of for getting #{snap.likes} likes!"
      ).generate
      @client.send_media(image_data, snap.username, view_duration: 10)

      puts "About to pin #{snap.id}"
      puts @pin_client.pin snap.image.url, @pin_board

      snap.sent_best_of = true
      snap.save
    end
  end
end
