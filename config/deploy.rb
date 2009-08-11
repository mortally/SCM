set :application, "computer-poker-analysis"
set :repository,  "ssh://deepmaize@aifa.eecs.umich.edu/Users/deepmaize/repos/computer-poker-analysis.git"
set :domain, "aifa.eecs.umich.edu"

set :deploy_to, "/home/deepmaize/deploy"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :scm, :git
set :deploy_via, :remote_cache

ssh_options[:paranoid] = false

set :user, 'deepmaize'
set :runner, 'deepmaize'
set :use_sudo, true

role :app, domain
role :web, domain
role :db, domain, :primary => true

# moves over server config files
task :update_config, :roles => [:app] do
  run "cp -Rf #{shared_path}/config/* #{release_path}/config/"
  run "echo $PATH"
end
after 'deploy:update_code', :update_config

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