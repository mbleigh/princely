# -*- encoding: utf-8 -*-
require File.expand_path('../lib/princely/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "princely"
  s.version = Princely::VERSION
  s.authors = ["Michael Bleigh", "Jared Fraser"]
  s.date = "2013-05-04"
  s.description = "A wrapper for the PrinceXML PDF generation library."
  s.email = ["michael@intridea.com", "dev@jsf.io"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.rdoc",
    "Rakefile",
    "lib/princely.rb",
    "lib/princely/pdf_helper.rb",
    "lib/princely/rails.rb",
    "lib/princely/version.rb"
  ]
  s.homepage = "http://github.com/mbleigh/princely"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "A simple Rails wrapper for the PrinceXML PDF generation library."

  s.add_development_dependency('rspec')
  s.add_development_dependency('rake')
end

