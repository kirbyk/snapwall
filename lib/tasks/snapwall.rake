task poll: :environment do
  Delayed::Job.enqueue PollJob.new
end

task clean: :environment do
  Delayed::Job.enqueue CleanerJob.new
end
