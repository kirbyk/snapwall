require ::File.expand_path('../config/environment',  __FILE__)

BlacklistMessageJob.new(ARGV[0]).perform
