class Poller

  def initialize(user, pass)
    @user = user
    @pass = pass
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
             Snap.find_by(snap_id: snap.id) || 
             snap.duration.nil?
        puts "Sender: #{snap.sender}"
        puts "Duration: #{snap.duration}"
        puts "Id: #{snap.id}"
        puts
        media_response = @client.media_for(snap.id)
        media = media_response.data[:media]
        continue unless media_response.success?
        raw_bytes = media.to_s
        s = Snap.new(username: snap.sender, duration: snap.duration, snap_id: snap.id)
        s.image_bytes = raw_bytes
        s.image_name = "#{snap.id}.jpg"
        s.image_content_type = "image/jpeg"
        if s.save
          @client.view snap.id
        end
      end
    end
    sleep 2
  rescue Exception => e
    STDERR.puts e.message
    STDERR.puts e.backtrace.join("\n")
  end
end
