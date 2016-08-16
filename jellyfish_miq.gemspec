$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'jellyfish_miq/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'jellyfish-miq'
  s.version     = JellyfishMiq::VERSION
  s.authors     = ['mafernando']
  s.email       = ['fernando_michael@bah.com']
  s.homepage    = 'http://projectjellyfish.org'
  s.summary     = 'Jellyfish MIQ Extension'
  s.description = 'An Extension to Support MIQ Services.'
  s.license     = 'APACHE'
  s.files       = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.add_dependency 'rails'
  s.add_dependency 'faker'
  s.add_dependency 'httparty'
  s.add_dependency 'excon'
end
