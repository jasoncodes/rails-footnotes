# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rails-footnotes/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = %q{rails3-footnotes}
  s.version     = Footnotes::VERSION
  s.date        = %q{2011-02-14}

  s.authors     = ["André Arko"]
  s.email       = %q{andre@arko.net}
  s.homepage    = %q{http://github.com/indirect/rails-footnotes}

  s.summary     = %q{Footnotes for Rails pages in development}
  s.description = %q{Adds footnotes to each page in your Rails app, containing useful development information as well as links to edit the controllers and views in your editor.}

  s.rubyforge_project = %q{rails-footnotes}
  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "rails", "~> 3.0"

  s.files         = Dir["[A-Z]*"] + Dir["lib/**/*"]
  s.test_files    = Dir["test/**/*.rb"]
  s.require_paths = ["lib"]
  s.rdoc_options  = ["--charset=UTF-8"]
end
