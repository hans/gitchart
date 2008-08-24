=begin
Copyright (c) 2008 Hans Engel
See the file LICENSE for licensing details.
=end

require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'

spec = eval(File.read('gitchart.gemspec'))

Rake::GemPackageTask.new(spec) do |pkg|
	pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
	puts 'generated latest version'
end

desc "build 'n' install"
task :bni => "pkg/#{spec.name}-#{spec.version}.gem" do
  puts `sudo gem install pkg/#{spec.name}-#{spec.version}.gem`
end