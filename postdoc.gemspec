$:.push File.expand_path('lib', __dir__)

Gem::Specification.new do |s|
  s.name        = 'postdoc'
  s.version     = '0.3.3'
  s.authors     = ['Frank Groeneveld']
  s.email       = ['frank@ivaldi.nl']
  s.homepage    = 'https://github.com/ivaldi/postdoc'
  s.summary     = 'Summary of Postdoc.'
  s.description = 'Description of Postdoc.'
  s.license     = 'BSD-2-Clause'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile']

  s.add_dependency 'chrome_remote', '>= 0.2.0'
  s.add_dependency 'rails', '>= 4.0.0', '< 6.1'
  s.add_development_dependency 'mocha'
end
