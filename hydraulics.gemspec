$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hydraulics/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hydraulics"
  s.version     = Hydraulics::VERSION
  s.authors     = ["Andrew Curley"]
  s.email       = ["andrew.curley@gmail.com"]
  s.homepage    = "http://projecthydraulics.org"
  s.summary     = "Summary of Hydraulics."
  s.description = "Description of Hydraulics."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "foreigner"
  s.add_dependency "ancestry"
  s.add_dependency "nokogiri"
  s.add_dependency "validates_timeliness" # https://github.com/adzap/validates_timeliness
  s.add_dependency "faker"
  # s.add_dependency "jquery-rails"
  
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'faker'
  s.add_development_dependency "sqlite3"
end
