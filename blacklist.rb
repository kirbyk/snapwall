require ::File.expand_path('../config/environment',  __FILE__)

Blacklist.create(username: ARGV[0])
