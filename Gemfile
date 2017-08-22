source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'

gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0.6'
gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'listen', '>= 3.0.5', '< 3.2'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'web-console', '>= 3.3.0'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'rails_12factor'
  gem 'pg', '~> 0.21.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


# Required Gems

gem 'jquery-rails'

# gem Plugins

gem 'devise'
gem 'stripe', '~> 3.2.0'
gem 'figaro', '~> 1.1.1'
gem 'pickadate-rails'
gem 'select2-rails', '~> 4.0', '>= 4.0.3'
gem 'foundation-rails'
gem 'font-awesome-sass', '~> 4.7.0'
gem 'paperclip', '~> 5.1.0'
gem 'custom_error_message', "~> 1.1.1"
gem 'nested_form_fields'


ruby '2.4.0'