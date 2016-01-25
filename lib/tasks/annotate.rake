desc "Annotate all models with the current schema"
task :annotate do
  puts `bundle exec annotate`
end

namespace :annotate do
  desc "Remove all annotations"
  task :delete do
    puts `bundle exec annotate --delete`
  end
end
