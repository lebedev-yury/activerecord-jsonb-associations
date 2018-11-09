$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'activerecord/jsonb/associations/version'

Gem::Specification.new do |spec|
  spec.name        = 'activerecord-jsonb-associations'
  spec.version     = ActiveRecord::JSONB::Associations::VERSION
  spec.authors     = ['Yury Lebedev']
  spec.email       = ['lebedev.yurii@gmail.com']
  spec.license     = 'MIT'
  spec.homepage    =
    'https://github.com/lebedev-yury/activerecord-jsonb-associations'
  spec.summary     =
    'Gem for storing association information using PostgreSQL JSONB columns'
  spec.description =
    'Use PostgreSQL JSONB fields to store association information '\
    'of your models'

  spec.files = Dir[
    '{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md'
  ]

  spec.required_ruby_version = '~> 2.0'

  spec.add_dependency 'activerecord', ['>= 5.1', '< 6']

  spec.add_development_dependency 'rspec', '~> 3.7.0'
end
