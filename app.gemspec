# -*- encoding: utf-8 -*-
# Ref: /

lib = File.expand_path('../vendor/bundle/', __FILE__)
$:.unshift lib unless $:.include?(lib)

lib = File.expand_path('../src/ruby/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'version'

Gem::Specification.new do |s|
  s.summary     = "RESTfull access to orientdb"
  s.description = "voir README.adoc"
  s.authors     = ["Robert St-Pierre"]
  s.email       = ["rstp@dironec.com"]

  s.executables  = ['application_bootstrap', 'rake']
  s.files        = Dir.glob("{bin,lib,src/ruby}/**/*")  + %w(LICENSE README.adoc CHANGELOG.md)

  s.name        = 'OrientREST'    #gem name
  s.version     = "#{VERSION}"
  s.platform    = Gem::Platform::CURRENT
  s.homepage    = "http://github.com/"

#  s.required_rubygems_version = ">= 1.3.6"
#  s.rubyforge_project         = "bundler"
#  s.add_runtime_dependency = ""
#  s.add_development_dependency "rspec"

  s.require_path = ['lib','src/ruby']
end
