require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'yard'
YARD::Rake::YardocTask.new

task default: [:rubocop, :spec]
