$:.push File.expand_path("../lib", __FILE__)

require 'cfn_toml/version'

Gem::Specification.new do |s|
  s.name          = 'cfn-toml'
  s.version       = CfnToml::VERSION
  s.authors       = ['Andrew Brown']
  s.email         = ['andew@teacherseat.com']
  s.summary       = 'Configuration file parsing for CFN Bash scripting'
  s.description   = 'Configuration file parsing for CFN Bash scripting'
  s.homepage      = 'https://github.com/teacherseat/cfn-toml'
  s.license       = 'MIT'

  s.files         = Dir["{lib}/**/*", "README.md"]
  s.test_files    = Dir["spec/**/*"]
  s.executables   = ['cfn-toml']
  s.require_paths = ['lib']
  s.bindir        = 'bin'

  s.required_ruby_version = '>= 2.4'
  s.add_dependency 'toml-rb' = '>= 2.0.1'
  s.add_development_dependency 'bundler', '>= 2.1.4'
end
