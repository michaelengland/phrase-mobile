require 'rubygems'
require 'spork'

Spork.prefork do
  require 'bundler/setup'
end

Spork.each_run do
  require 'phrase_mobile'
end
