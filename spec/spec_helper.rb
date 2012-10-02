require 'spork'

Spork.prefork do
  require 'bundler/setup'
  require 'rubygems'
  require 'webmock/rspec'
end

Spork.each_run do
  require 'phrase_mobile'
end
