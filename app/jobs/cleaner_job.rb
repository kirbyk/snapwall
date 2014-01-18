require File.join(Rails.root, "lib", "cleaner.rb")

class CleanerJob
  def perform
    Cleaner.new(ENV['USER'], ENV['PASS']).clean
  end
end
