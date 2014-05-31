# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_notifiable_redmine/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_notifiable_redmine"
  s.version     = ActsAsNotifiableRedmine::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nicolas Rodriguez"]
  s.email       = ["nrodriguez@jbox-web.com"]
  s.homepage    = "https://github.com/jbox-web/acts_as_notifiable_redmine"
  s.summary     = %q{A Ruby gem who provides a small DSL to register Pusher channels and events in Redmine}
  s.license     = 'MIT'

  s.rubyforge_project = "acts_as_notifiable_redmine"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
