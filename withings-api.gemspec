# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "withings-api/version"

Gem::Specification.new do |s|
  s.name        = "withings-api"
  s.version     = Withings::Api::VERSION
  s.authors     = ["webmonarch"]
  s.email       = ["eric@collectivegenius.net"]
  s.homepage    = ""
  s.summary     = "A simple Ruby implementation of the Withings API."
  s.description = "A simple Ruby implementation of the Withings API. See http://www.withings.com/en/api/wbsapiv2"

  s.rubyforge_project = "withings-api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "oauth", "~> 0.4.5"
  s.add_runtime_dependency "json"
  # s.add_runtime_dependency "rest-client"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"
  s.add_development_dependency "capybara"
  s.add_development_dependency "simplecov"

end
