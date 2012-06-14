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
  s.require_paths = ["lib/**/*", "app/**/*", "validators/**/*"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  # ---------------------------------------   

  s.add_dependency "rails"
  s.add_dependency "ancestry"
  s.add_dependency "nokogiri"
  s.add_dependency "validates_timeliness", "~> 3.0.6" # https://github.com/adzap/validates_timeliness
  s.add_dependency "foreigner"

end
