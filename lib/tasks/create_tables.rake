require 'dotenv'
require 'dotenv/tasks'
Dotenv.load

namespace :ango do
  desc "Creation des bases de donnees / SQL"
  task :create_tables => :dotenv do
    sh "psql -h '127.0.0.1' -p 5432 -d #{ENV["DATABASE_NAME"]} -U #{ENV["DATABASE_USER_NAME"]} -f ./db/structure.sql"
  end

end
