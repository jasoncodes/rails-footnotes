require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Run tests for Footnotes.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task :default => :test

desc 'Generate documentation for Footnotes.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Footnotes'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('MIT-LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
      #skipping: churn, :stats
      config.metrics  = [:saikuro, :flog, :flay, :reek, :roodi, :rcov]
      # config.graphs   = [:flog, :flay, :reek, :roodi, :rcov]
      config.rcov[:rcov_opts] << "-Itest"
  end
rescue LoadError
end
