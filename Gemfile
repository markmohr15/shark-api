source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.2', '>= 6.0.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
gem 'devise'                      # Use devise as authentication module
gem 'devise-jwt', '~> 0.5.8'      # Use JWT token authentication with devise
gem 'bcrypt', '~> 3.1.7'          # Use ActiveModel has_secure_password
gem 'dry-configurable', '0.9.0'   # lock this in.  upgrade breaks authentication
gem 'graphql'
gem 'graphql-errors'
gem 'rack-cors'
gem 'puma', '~> 4.3'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'httparty'
gem 'mechanize'
gem 'smarter_csv'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'  
  gem 'annotate'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
