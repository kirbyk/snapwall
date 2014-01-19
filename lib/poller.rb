require "base64"

class Poller

  def initialize(user, pass, host, path)
    @user = user
    @pass = pass
    @host = host
    @path = path
  end

  def poll
    puts "Starting poller"
    @client = Snapcat::Client.new(@user)
    puts "Logging in with username #{@user}"
    @client.login(@pass)
    puts "Logged in!"

    puts "Fetching updates"
    @client.fetch_updates
    snaps = @client.user.snaps_received
    snaps.each do |snap|
      unless snap.status.opened? || 
             snap.duration.nil?

        puts "Sender: #{snap.sender}"
        puts "Duration: #{snap.duration}"
        puts "Id: #{snap.id}"
        puts
        media_response = @client.media_for(snap.id)
        media = media_response.data[:media]
        continue unless media_response.success?
        raw_bytes = media.to_s
        base64 = Base64.encode(raw_bytes)
        hash = {
          username: snap.sender,
          duration: snap.duration,
          snap_id: snap.id,
          base64: base64
        }
        uri = URI.parse(@host)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(@path)
        request.add_field('Content-Type', 'application/json')
        request.body = hash
        response = http.request(request)
        if response.code == "200"
          @client.view snap.id
        end
      end
    end
    sleep 2
  rescue Exception => e
    STDERR.puts e.message
    STDERR.puts e.backtrace.join("\n")
    sleep 2
  end
end
