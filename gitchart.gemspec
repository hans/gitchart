=begin
Copyright (c) 2008 Hans Engel
See the file LICENSE for licensing details.
=end

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'gitchart'
  s.version = '1.1'
  s.date = '2008-08-23'
  s.homepage = 'http://gitchart.rubyforge.org'
  s.author = 'Hans Engel'
  s.email = 'spam.me@engel.uk.to'
  s.summary = 'Generate cool stats about Git repositories'
  s.files = [
    'LICENSE',
    'Rakefile',
    'gitchart.gemspec',
    'lib/gitchart.rb',
    'lib/platform.rb',
    'bin/git-chart']
  s.bindir = 'bin'
  s.executables = ['git-chart']
  s.require_paths = ['lib']
  s.add_dependency('gchartrb', '>= 0.8')
  s.add_dependency('grit', '>= 0.9.3')
end
