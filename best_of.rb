require ::File.expand_path('../config/environment',  __FILE__)
require "./lib/image_generator"

@client = Snapcat::Client.new(ENV['USER'])
@client.login(ENV['PASS'])
data = ImageGenerator.new(ARGV[1]).generate
@client.send_media(data, ARGV[0], view_duration: 10)
