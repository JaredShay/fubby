Gem::Specification.new do |gem|
  gem.authors       = ['JaredShay']
  gem.email         = ['jared.shay@gmail.com']
  gem.description   = %q{Functional library for ruby}
  gem.summary       = %q{Functional library for ruby}
  gem.homepage      = 'https://github.com/jaredshay/fubby'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = 'fubby'
  gem.require_paths = ['lib']
  gem.version       = '0.0.0'
  gem.license       = 'MIT'

  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'minitest-reporters'
end
