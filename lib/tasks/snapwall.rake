require "./lib/poller"

task poll: :environment do
  Poller.new(ENV['USER'], ENV['PASS'], ENV['HOST'], ENV['PATH'])
end

task clean: :environment do
  Delayed::Job.enqueue CleanerJob.new
end
