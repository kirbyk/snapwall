require File.join(Rails.root, 'lib', 'poller.rb')

class PollJob
  def perform
    Poller.new(ENV['USER'], ENV['PASS']).poll
    Delayed::Job.enqueue PollJob.new
  end
end
