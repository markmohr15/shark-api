source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7'
gem 'pg', '>= 0.18', '< 2.0'
gem 'devise'                      # Use devise as authentication module
gem 'devise-jwt'     # Use JWT token authentication with devise
gem 'bcrypt', '~> 3.1.7'          # Use ActiveModel has_secure_password
gem 'graphql'
gem 'graphql-errors'
gem 'rack-cors'
gem 'puma', '~> 5.6'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'httparty'
gem 'mechanize'
gem 'smarter_csv'
gem 'bugsnag'
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
gem 'net-smtp', require: false
gem 'net-imap', require: false
gem 'net-pop', require: false
gem "barnes"

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
