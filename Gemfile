source 'https://rubygems.org'
gem 'rails', '7.1.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2.2'
gem 'jquery-rails', '>= 4.0.1'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0', '>= 2.0.0'
gem 'jquery-cookie-rails'
gem 'bootstrap-sass', '~> 3.0.3.0'

# for static pages
gem 'high_voltage'

# RMagick for generating snaps we send
gem "rmagick", "2.13.2", :require => 'RMagick'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '>= 1.0.0', require: false
end

group :development do
  gem 'pry-rails'
end

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

group :staging do
  gem 'pg'
  gem 'rails_12factor'
end

gem "snapcat", github: "rickbutton/snapcat"
gem "foreman"
gem "paperclip", ">= 3.5.3"
gem 'delayed_job_active_record', '>= 4.1.5'
gem 'aws-sdk'
gem 'newrelic_rpm'
