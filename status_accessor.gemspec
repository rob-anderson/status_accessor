# -*- encoding: utf-8 -*-
require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'status_accessor'
  s.version     = StatusAccessor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.date        = '2012-03-26'
  s.summary     = "utility for handling status-like fields"
  s.description = "utility for handling status-like fields"
  s.authors     = "Rob Anderson"
  s.email       = 'rob.anderson@paymentcardsolutions.co.uk'
  s.files       = ["lib/status_accessor.rb"]
  s.homepage    = 'https://github.com/rob-anderson/status_accessor.git'

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
