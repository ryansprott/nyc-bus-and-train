source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 6.1.4.4'
gem 'pg', '~> 1.3.1'
gem 'puma', '~> 5.6.1'
gem 'webpacker', '~> 5.4.3'
gem 'jbuilder', '~> 2.11.5'

gem 'protobuf'
gem 'gtfs-realtime-bindings'

gem 'bootsnap', '>= 1.10.3', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 4.2.0'
  gem 'listen', '~> 3.7.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
