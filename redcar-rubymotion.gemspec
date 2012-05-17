require 'rubygems'

Gem::Specification.new do |s|
  s.name = "redcar-rubymotion"
  s.version = "0.5"
  s.author = "Delisa Mason"
  s.email = "iskanamagus@gmail.com"
  s.homepage = "https://kattrali.github.com/redcar-rubymotion"
  s.platform = Gem::Platform::RUBY
  s.summary = "RubyMotion workflow integration for redcar editor"
  s.description = %Q{Redcar+RubyMotion - A plugin which adds RubyMotion workflow support to Redcar editor.}
  s.files = Dir.glob("{lib,docs,Bundles,scripts}/**/*") + %w(license README.md notes.md plugin.rb)
  s.license = "GPLv3"
  s.require_path = "lib"
  s.has_rdoc = true
  s.extra_rdoc_files = ["readme.md",'notes.md']
  # s.add_dependency("dependency", ">= 0.x.x")
end