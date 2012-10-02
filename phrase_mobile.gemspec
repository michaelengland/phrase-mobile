require File.expand_path('../lib/phrase_mobile/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'libxml-ruby', '~> 2.3.3'
  gem.add_dependency 'typhoeus', '~> 0.4.2'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'spork'
  gem.add_development_dependency 'webmock'
  gem.authors = ['Michael England']
  gem.description = %q{Ruby Gem for importing/exporting Android & iPhone strings from/to Phrase.}
  gem.email = %w(mg.england@gmail.com)
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/michaelengland/phrase-mobile'
  gem.name = 'phrase_mobile'
  gem.require_paths = %w(lib)
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.summary = %q{A Phrase Importer/Exporter for Mobile.}
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = PhraseMobile::Version
end
