set :application, "syweb"
set :repository,  "git@github.com:syweb/syweb.git"
set :user,        "ubuntu"
set :domain,      "#{user}@insightmethods.info"
set :deploy_to,   "/mnt/apps/#{application}"
set :revision,    "master"
set :use_sudo, false

set :scm, :git
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "insightmethods.info"                          # Your HTTP server, Apache/etc
role :app, "insightmethods.info"                          # This may be the same as your `Web` server
role :db,  "insightmethods.info", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy do
  desc "Symlink shared resources on each release - not used"
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/sites #{release_path}/public/sites"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  end
end

after 'deploy:symlink', 'deploy:symlink_shared'

# rvmsudo passenger start -e production -p 80 --user=ubuntu