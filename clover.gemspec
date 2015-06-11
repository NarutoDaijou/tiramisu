# coding: utf-8

name, version = 'clover 0.0.0'.split
Gem::Specification.new do |spec|
  spec.name          = name
  spec.version       = version
  spec.authors       = ['Slee Woo']
  spec.email         = ['mail@sleewoo.com']
  spec.description   = 'Simplistic yet powerful testing library for Ruby'
  spec.summary       = [name, version]*'-'
  spec.homepage      = 'https://github.com/sleewoo/' + name
  spec.license       = 'MIT'

  spec.files = Dir['**/{*,.[a-z]*}'].reject {|e| e =~ /\.(gem|lock)\Z/}
  spec.require_paths = ['lib']

  spec.executables = Dir['bin/*'].map{ |f| File.basename(f)}

  spec.required_ruby_version = '>= 2'

  spec.add_runtime_dependency 'tty-progressbar', '~> 0.5'
  spec.add_runtime_dependency 'tty-screen',      '~> 0.1'
  spec.add_runtime_dependency 'pastel',          '~> 0.4'
  spec.add_runtime_dependency 'coderay',         '~> 1'

  spec.add_development_dependency 'minitest', '~> 5.5'
  spec.add_development_dependency 'bundler',  '~> 1.8'
  spec.add_development_dependency 'rake',     '~> 10.4'
end
