require File.join(Rails.root, "lib", "blacklist_image_generator.rb")

class BlacklistMessageJob < Struct.new(:username)
  def perform
    puts "Sending blacklist message to #{username}"
    @client = Snapcat::Client.new(ENV['USER'])
    @client.login(ENV['PASS'])
    image_data = BlacklistImageGenerator.new.generate
    @client.send_media(image_data, username, view_duration: 10)
  end
end
