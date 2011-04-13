# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "trimmer/version"

Gem::Specification.new do |s|
  s.name        = "trimmer"
  s.version     = Trimmer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pablo Villable", "Saimon Moore"]
  s.email       = ["pablo@teambox.com", "saimon@teambox.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "trimmer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency 'rack', '>= 0.9.1'
  s.add_dependency 'i18n', '>= 0.5.0'
  s.add_dependency 'tilt', '>= 1.2.2'
  s.add_development_dependency 'test-spec', '>= 0.9.0'
  s.add_development_dependency 'haml', '>= 3.0.25'
  s.add_development_dependency 'json', '>= 1.1'
end
