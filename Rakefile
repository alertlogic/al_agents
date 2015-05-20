begin

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  require 'foodcritic'
  require 'foodcritic/rake_task'
  FoodCritic::Rake::LintTask.new

  desc 'Check for lint and style problems'
  task inspect: [:rubocop, :foodcritic]

  desc 'Default is ...'
  task default: [:inspect]

rescue LoadError
  puts 'A gem is missing. Please run "bundle install".'
end
