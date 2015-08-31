$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_job/rnf/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_job-rnf"
  s.version     = ActiveJob::RNF::VERSION
  s.authors     = ["Carsten Zimmermann"]
  s.email       = ["cz@aegisnet.de"]
  s.summary     = "Silently ignores ActiveRecord::RecordNotFound errors for ActiveJob deserialization"
  s.description = <<-EODESC
Assuming that a queued job has lost its raison d'être when its argument had been deleted, ActiveJob::RNF ignores deserialization errors originating from a failed attempt to load that resource.
EODESC
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.2.0", "< 5.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
