$:.push File.expand_path('lib', __dir__)
require 'rails_growth/version'

Gem::Specification.new do |spec|
  spec.name = 'rails_growth'
  spec.version = RailsGrowth::VERSION
  spec.authors = ['qinmingyuan']
  spec.email = ['mingyuan0715@foxmail.com']
  spec.homepage = 'https://github.com/work-design/rails_growth'
  spec.summary = 'Summary of RailsGrowth.'
  spec.description = 'Description of RailsGrowth.'
  spec.license = 'LGPL-3.0'

  spec.files = Dir[
    '{app,config,db,lib}/**/*',
    'LICENSE',
    'Rakefile',
    'README.md'
  ]

  spec.add_dependency 'rails_com', '~> 1.2'
  spec.add_development_dependency 'sqlite3'
end
