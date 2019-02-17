# frozen_string_literal: true

source 'https://rubygems.org'

ruby File.read('.ruby-version').match(/\d\.\d.\d/)[0]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'puma'
gem 'rails'

gem 'active_model_serializers', '~> 0.10.0'
gem 'dotenv-rails'
gem 'foreman'
gem 'mysql2'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'overcommit', require: false

  # Spring speeds up development by keeping your application running
  # in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'

  gem 'rubocop', require: false
  gem 'rubycritic', require: false
end
