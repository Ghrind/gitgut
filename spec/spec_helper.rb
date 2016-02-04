$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# Code coverage
require 'simplecov'
SimpleCov.start do
  add_filter "/vendor/"
  add_filter "/spec/"
end

require 'gitgut'
require 'webmock/rspec'
