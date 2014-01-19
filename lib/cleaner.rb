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
      "(sent_best_of = 'f' OR sent_best_of IS NULL) AND created_at < ?",
      THRESHOLD.ago
    )
    snaps.each do |snap|
      puts "Cleaning snap from #{snap.username}"
      image_data =  ImageGenerator.new(snap.likes).generate
      @client.send_media(image_data, snap.username, view_duration: 10)

      snap.sent_best_of = true
      snap.save
    end
  end
end
