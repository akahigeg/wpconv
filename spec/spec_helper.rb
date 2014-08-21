# -*- coding: utf-8 -*-

$TESTING=true

require 'rubygems'
require 'rspec'
require 'wpconv'

Dir[File.join(File.dirname(__FILE__), "..", "lib", "**/*.rb")].each do |f|
  require f
end

RSpec.configure do |config|
  config.color_enabled = true
  config.filter_run_excluding :skip => true
end
