require File.join(Rails.root, "lib", "image_generator.rb")

class Cleaner

  def initialize(user, pass)
    @user = user
    @pass = pass
  end

  def clean
    @client = Snapcat::Client.new(@user)
    @client.login(@pass)
    snaps = Snap.best.where(
      "sent_best_of = ? AND created_at < ?",
      false,
      THRESHOLD.ago
    )
    snaps.each do |snap|
      image_data =  ImageGenerator.new(
        "Your snap has made Best Of for getting #{snap.likes} likes!"
      ).generate
      @client.send_media(image_data, snap.username, view_duration: 10)
      snap.sent_best_of = true
      snap.save
    end
  end
end