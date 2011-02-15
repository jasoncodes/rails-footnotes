# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = %q{rails-footnotes}
  s.version     = "3.6.7"
  s.date        = %q{2010-08-17}

  s.authors     = ["Keenan Brock"]
  s.email       = %q{keenan@thebrocks.net}
  s.homepage    = %q{http://github.com/josevalim/rails-footnotes}

  s.description = %q{Every Rails page has footnotes that gives information about your application and links back to your editor.}
  s.summary     = %q{Every Rails page has footnotes that gives information about your application and links back to your editor.}

  s.rubyforge_project = %q{rails-footnotes}
  s.rubygems_version  = %q{1.3.6}

  s.files         = Dir["[A-Z]*"] + Dir["lib/**/*"]
  s.test_files    = Dir["test/**/*.rb"]
  s.require_paths = ["lib"]

  s.extra_rdoc_files = ["README"]
  s.rdoc_options     = ["--charset=UTF-8"]
end
