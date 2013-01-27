require 'rubygems'

Gem::Specification.new do |s|
  s.name             = "redcar-rubymotion"
  s.version          = "0.9.1"
  s.author           = "Delisa Mason"
  s.email            = "iskanamagus@gmail.com"
  s.homepage         = "https://kattrali.github.com/redcar-rubymotion"
  s.platform         = Gem::Platform::RUBY
  s.summary          = "RubyMotion workflow integration for redcar editor"
  s.description      = %Q{Redcar+RubyMotion - A plugin which adds RubyMotion workflow support to Redcar editor.}
  s.files            = Dir.glob("{lib,docs,Bundles,scripts,templates}/**/*") + %w(LICENSE readme.md notes.md plugin.rb)
  s.license          = "MIT"
  s.require_path     = "lib"
  s.has_rdoc         = true
  s.extra_rdoc_files = %w[readme.md notes.md LICENSE]
end