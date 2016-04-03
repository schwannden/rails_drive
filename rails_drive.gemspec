$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_drive/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_drive"
  s.version     = RailsDrive::VERSION
  s.authors     = ["schwannden"]
  s.email       = ["schwannden@gmail.com"]
  s.homepage    = "https://github.com/schwannden/rails_drive"
  s.summary     = "Rails plugin for Google Drive"
  s.description = "A Rails plugin for Google drive that enables Drive documents and folders to act like active record"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4"

  s.add_runtime_dependency "google-api-client", "~> 0.9"
  s.add_development_dependency "sqlite3", "~> 1.3"
end
