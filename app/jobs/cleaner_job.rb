require File.join(Rails.root, "lib", "cleaner.rb")

class CleanerJob
  def perform
    Cleaner.new(ENV['USER'], ENV['PASS'], ENV['PIN_USER'], ENV['PIN_PASS'], ENV['PIN_BOARD']).clean
  end
end
