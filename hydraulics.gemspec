# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hydraulics/version"

Gem::Specification.new do |s|
  s.name        = "hydraulics"
  s.version     = Hydraulics::VERSION
  s.authors     = ["Andrew Curley"]
  s.email       = ["andrew.curley@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{The Hydraulics Plguin}
  s.description = %q{Workflow application}

  s.rubyforge_project = "hydraulics"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  # ---------------------------------------   

  s.add_dependency "rails", "3.1"
  s.add_dependency "sqlite3"
  s.add_dependency "carmen"
  s.add_dependency "activeadmin"
  s.add_dependency "sunspot_rails"
  s.add_dependency "nokogiri"

end
