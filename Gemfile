source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
ruby '2.0.0'
gem 'rails', '4.0.0'

gem 'devise', '3.1.1'

gem 'haml-rails'
gem 'haml2slim'
gem 'html2haml'

# Use simple form for frontend
gem 'simple_form', '>= 3.0.0.rc'

# Use the bootstrap for frontend
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'will_paginate_mongoid'
gem 'bootstrap-datepicker-rails'


# Use jquery as the JavaScript library
gem 'jquery-rails'

# Use parsley for front end validate
gem 'parsley-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'


# Use MongoID
gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'
gem 'delayed_job_mongoid', :github => 'shkbahmad/delayed_job_mongoid'

# Use carrierwave for upload document and image
gem 'carrierwave', :git => "git://github.com/jnicklas/carrierwave.git"
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'

# Use amazon service for image uploader
gem 'aws-sdk'
gem 'fog'
gem 'unf'
#gem 'rmagick'
gem 'mini_magick'


gem 'redis'
gem 'resque', '~> 2.0.0.pre.1', github: "resque/resque"

#Use Grape for API
gem 'grape'

group :assets do
  # Use SCSS for stylesheets
	gem 'sass-rails', '~> 4.0.0'
  # Use Uglifier as compressor for JavaScript assets
	gem 'uglifier', '>= 1.3.0'
	# Use CoffeeScript for .js.coffee assets and views
	gem 'coffee-rails', '~> 4.0.0'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'hub', :require=>nil
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'debugger'
  gem 'letter_opener'
  #gem 'rails-erd'
end

group :test do
  gem 'database_cleaner', '1.0.1'
end

group :development, :test do
  gem 'pry'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'mongoid-rspec'
end

group :production, :heroku do
  gem 'rails_12factor'
end


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
