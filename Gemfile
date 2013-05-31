source "https://rubygems.org"

gem 'sinatra'

group :development, :test do
  gem "fakefs",                     "~> 0.4.2", :require => "fakefs/safe"
  gem "timecop",                    "~> 0.6.1"
end

group :test do
  gem "webmock",                    "~> 1.8.0"
  gem "debugger"
  gem "rspec"
end

group :development do
  gem "thin",                       "~> 1.5.0"
  gem "foreman"
end
