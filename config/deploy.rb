set :application, "analysis"
set :repository,  "git@github.com:DoctorTeeth/SCM"
set :domain, "manx.eecs.umich.edu"

set :deploy_to, "/home/auggie/newguy"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :scm, :git
#set :deploy_via, :remote_cache

ssh_options[:paranoid] = false

default_run_options[:pty] = true


set :user, 'auggie'
#set :runner, 'auggie'
set :use_sudo, false

deploy.task :restart, :roles => :app do
  run "touch #{current_path}/tmp/restart.txt"
end

role :app, domain
role :web, domain
role :db, domain, :primary => true

# moves over server config files
task :update_config, :roles => [:app] do
  run "cp -Rf #{shared_path}/config/* #{release_path}/config/"
  run "echo $PATH"
end
after 'deploy:update_code', :update_config

# moves over server config files
task :update_sample_symlink, :roles => [:app] do
  run "ln -s #{shared_path}/samples #{release_path}/public/samples"
end
after 'deploy:update_code', :update_sample_symlink

# mongrel-based overrides of the default tasks

namespace :deploy do
  namespace :mongrel do
    [ :stop, :start, :restart ].each do |t|
      desc "#{t.to_s.capitalize} the mongrel appserver"
      task t, :roles => :app do
        #invoke_command checks the use_sudo variable to determine how to run the mongrel_rails command
        invoke_command "mongrel_rails cluster::#{t.to_s} -C #{mongrel_conf}", :via => run_method
      end
    end
  end

  desc "Custom restart task for mongrel cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.mongrel.restart
  end

  desc "Custom start task for mongrel cluster"
  task :start, :roles => :app do
    deploy.mongrel.start
  end

  desc "Custom stop task for mongrel cluster"
  task :stop, :roles => :app do
    deploy.mongrel.stop
  end
end

namespace :backgroundrb do
  desc "Stop the backgroundrb server"
  task :stop , :roles => :app do
    run "cd #{current_path} && ./script/backgroundrb stop -e production"
  end

  desc "Start the backgroundrb server"
  task :start , :roles => :app do
    run "cd #{current_path} && nohup ./script/backgroundrb start -e production  > /dev/null 2>&1"
  end

  desc "Start the backgroundrb server"
  task :restart, :roles => :app do
    backgroundrb.stop
    backgroundrb.start
  end
end
