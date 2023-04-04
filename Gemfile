source 'https://rubygems.org'
gem 'rails', '6.1.7.3'
gem 'sass-rails', '~> 5.0.8'
gem 'uglifier', '>= 2.7.2'
gem 'coffee-rails', '~> 4.2.2'
gem 'jquery-rails', '>= 4.4.0'
gem 'turbolinks', '>= 5.0.0'
gem 'jbuilder', '~> 1.5', '>= 1.5.3'
gem 'jquery-cookie-rails'
gem 'bootstrap-sass', '~> 3.4.0.0'

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
gem "paperclip", ">= 5.2.1"
gem 'delayed_job_active_record', '>= 4.1.5'
gem 'aws-sdk', '>= 1.52.0'
gem 'newrelic_rpm'
