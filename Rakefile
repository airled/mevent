require_relative './init/db'
Sequel.extension :migration

namespace :db do
  desc "Prints current schema version"
  task :version do
    version = if DB.tables.include?(:schema_info)
      DB[:schema_info].first[:version]
    end || 0
  puts "Schema Version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate do
    Sequel::Migrator.run(DB, "db/migrate")
    Rake::Task['db:version'].execute
  end
  
  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, :target do |t, args|
    args.with_defaults(:target => 0)
    Sequel::Migrator.run(DB, "db/migrate", :target => args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    Sequel::Migrator.run(DB, "db/migrate", :target => 0)
    Sequel::Migrator.run(DB, "db/migrate")
    Rake::Task['db:version'].execute
  end
end

namespace :app do
  task :run do
    system('bundle exec thin -C config/thin.yml start')
  end

  task :stop do
    if File.exist?('./tmp/pids/thin.3002.pid')
      pid = File.open('./tmp/pids/thin.3002.pid') { |file| file.read }
      system("kill #{pid}")
      puts "Thin (pid #{pid}) stopped"
    else
      puts 'Could not find pidfile. Check if the server is running'
    end
  end
end

task :deploy do
  system('bundle exec mina full_deploy')
end