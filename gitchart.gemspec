Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'gitchart'
  s.version = '1.0'
  s.date = '2008-08-23'
  s.homepage = 'http://github.com/hans/gitchart'
  s.author = 'Hans Engel'
  s.email = 'spam.me@engel.uk.to'
  s.summary = 'Generate cool stats about Git repositories'
  s.files = ['lib/gitchart.rb', 'bin/git-chart']
  s.bindir = 'bin'
  s.executables = ['git-chart']
  s.require_paths = ['lib']
  s.add_dependency('gchartrb', '>= 0.8')
  s.add_dependency('schacon-grit', '>= 0.9.3')
end
