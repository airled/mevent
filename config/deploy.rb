require 'mina/bundler'
require 'mina/git'
require 'mina/rbenv'

set :domain, '198.20.105.55'
set :deploy_to, '/home/mevent'
set :repository, 'https://github.com/airled/mevent.git'
set :branch, 'master'
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log']
set :user, 'mevent'

task :environment do
  invoke :'rbenv:load'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml' and 'secrets.yml'."]
  queue %[
    repo_host=`echo $repo | sed -e 's/.*@//g' -e 's/:.*//g'` &&
    repo_port=`echo $repo | grep -o ':[0-9]*' | sed -e 's/://g'` &&
    if [ -z "${repo_port}" ]; then repo_port=22; fi &&
    ssh-keyscan -p $repo_port -H $repo_host >> ~/.ssh/known_hosts
  ]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
  end
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'
    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
    queue 'bundle exec rake db:migrate'
  end
end

namespace :app do
  task :start => :environment do
    queue 'cd current && bundle exec rake app:start'
  end

  task :stop => :environment do
    queue 'cd current && bundle exec rake app:stop'
  end
end

task :full_deploy => :environment do
  invoke :'app:stop'
  invoke :deploy
  invoke :'app:start'
end
