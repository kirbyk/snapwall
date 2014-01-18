task poll: :environment do
  Delayed::Job.enqueue PollJob.new
end
