# -*- encoding: utf-8 -*-
require File.expand_path('../lib/princely/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "princely"
  s.version = Princely::Version.to_s
  s.authors = ["Michael Bleigh", "Jared Fraser"]
  s.date = "2013-01-16"
  s.description = "A wrapper for the PrinceXML PDF generation library."
  s.summary = "A simple Rails wrapper for the PrinceXML PDF generation library."
  s.email = %w[michael@intridea.com dev@jsf.io]
  s.files = %w[
    MIT-LICENSE
    README.md
    Rakefile
    lib/princely.rb
    lib/princely/asset_support.rb
    lib/princely/logging.rb
    lib/princely/pdf.rb
    lib/princely/pdf_helper.rb
    lib/princely/rails.rb
    lib/princely/stdout_logger.rb
    lib/princely/version.rb
  ]
  s.homepage = "http://github.com/mbleigh/princely"
  s.require_paths = %w[lib]
  s.rubygems_version = "1.8.11"

  s.add_development_dependency("rspec")
end

