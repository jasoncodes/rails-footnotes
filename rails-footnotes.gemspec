# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = %q{rails-footnotes}
  s.version     = "4.0.0.pre"
  s.date        = %q{2010-08-17}

  s.authors     = ["André Arko", "Roman Babenko", "José Valim", "Keenan Brock"]
  s.email       = %q{andre@arko.net}
  s.homepage    = %q{http://github.com/indirect/rails-footnotes}

  s.summary     = %q{Footnotes for Rails pages in development}
  s.description = %q{Adds footnotes to each page in your Rails app, containing useful development information as well as links to edit the controllers and views in your editor.}

  s.rubyforge_project = %q{rails-footnotes}
  s.rubygems_version  = %q{1.3.6}

  s.files         = Dir["[A-Z]*"] + Dir["lib/**/*"]
  s.test_files    = Dir["test/**/*.rb"]
  s.require_paths = ["lib"]

  s.extra_rdoc_files = ["README"]
  s.rdoc_options     = ["--charset=UTF-8"]
end
