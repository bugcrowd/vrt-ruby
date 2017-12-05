require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Override our build task to ensure VRT git submodules are present'
task 'build' do
  submodule_status = `git submodule init && git submodule update`
  unless submodule_status.empty?
    raise 'git submodules were not up-to-date. Please rebuild!'
  end
end
