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

  s.files = Dir["{app,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency "rails", "~> 4.1"
  s.add_dependency "request_store", "~> 1.1.0"

  s.add_development_dependency "sqlite3", "~> 1.3.10"
  s.add_development_dependency "database_cleaner", "~> 1.3.0"
end
