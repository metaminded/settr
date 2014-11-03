$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "settr/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "settr"
  s.version     = Settr::VERSION
  s.authors     = ["Philipp Hirsch"]
  s.email       = ["itself@hanspolo.net"]
  s.homepage    = "https://github.com/metaminded/settr/"
  s.summary     = "Easy settings for rails"
  s.description = "Coming soon"
  s.license     = "MIT"

  s.files = Dir["{app,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0.beta4"

  s.add_development_dependency "sqlite3"
end
