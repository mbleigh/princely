# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'princely/version'

Gem::Specification.new do |s|
  s.name = "princely"
  s.version = Princely::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Bleigh", "Jared Fraser"]
  s.date = "2012-01-25"
  s.description = "A wrapper for the PrinceXML PDF generation library."
  s.email = ["michael@intridea.com", "dev@jsf.io"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/princely.rb",
    "lib/princely/pdf_helper.rb",
    "lib/princely/rails.rb",
    "lib/princely/version.rb"
  ]
  s.homepage = "http://github.com/mbleigh/princely"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "A simple Rails wrapper for the PrinceXML PDF generation library."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

