class Poller

  def initialize(user, pass)
    @user = user
    @pass = pass
  end

  def poll
    begin
      puts "Starting poller"
      @client = Snapcat::Client.new(@user)
      puts "Logging in with username #{@user}"
      @client.login(@pass)
      puts "Logged in!"

      while true
        puts "Fetching updates"
        @client.fetch_updates
        puts @client.user.snaps_received.map(&:id).join(", ")
        sleep 5
      end
    rescue
      puts $!, $@
      sleep 5
      poll
    end
  end
end

task :poll do
  Poller.new(ENV['USER'], ENV['PASS']).poll
end
