require 'mongrel_cluster/recipes'

set :application, "huffrun"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :repository, "git+ssh://git.local.wrladv.com/git/#{application}.git"

# install gem: capistrano_rsync_with_remote_cache
set :deploy_via, :rsync_with_remote_cache
set :repository_cache, "cached-copy"
set :rsync_options, "-rz --delete --exclude=.svn --exclude=.git"
ssh_options[:keys] = %w(~/.ssh/id_dsa ~/.ssh/id_rsa)

# :deploy_via :copy may need this
# http://www.mail-archive.com/capistrano%40googlegroups.com/msg02543.html
set :synchronous_connect, true

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/data/www/vhosts/#{application}"

# The user who runs the mongrel daemon
set :runner, "www-data"
# server definitions
server = "gato.wrladv.com"
role :app, "spider.wrladv.com"
role :web, server
role :db,  server, :primary => true

# the group that should own most files
set :group, 'staff'

set :mongrel_conf, "/etc/mongrel_cluster/#{application}.yml"

#####################################################################

namespace :deploy do
	after "deploy", "deploy:cleanup"

  task :fix_setup_perms do
    sudo "chown -R #{runner} #{shared_path}/log #{shared_path}/pids #{shared_path}/system"
  end
  after "deploy:setup", "deploy:fix_setup_perms"
  after "deploy:update_code", "deploy:fix_setup_perms"

  task :fix_upload_perms do
    sudo "chown -R #{runner} #{release_path}/tmp/*"

    # make sure the server-side cache has good permissions too
    sudo "chgrp -R #{group} #{shared_path}/#{repository_cache}"
    sudo "chmod -R g+w #{shared_path}/#{repository_cache}"
    # sh -c necessary here because of how cap runs sudo commands; we need the "xargs sudo" to have root
    sudo "sh -c 'find #{shared_path}/#{repository_cache} -type d -print0 | xargs -0 chmod g+s'"
  end
  after "deploy:update_code", "deploy:fix_upload_perms"


  task :create_attachment_fu_dir do
    sudo "rm -rf #{shared_path}/attachment_fu"
    run "mkdir #{shared_path}/attachment_fu"
    sudo "chown -R #{runner}:#{group} #{shared_path}/attachment_fu"
    sudo "chmod g+ws #{shared_path}/attachment_fu"
  end
  after "deploy:setup", "deploy:create_attachment_fu_dir"

  task :link_attachment_fu_dir do
    run "rm -rf #{release_path}/tmp/attachment_fu"
    run "ln -nfs #{shared_path}/attachment_fu #{release_path}/tmp"

    # the has_attachment calls should be changed to have
    # :path_prefix => 'public/system/images',
    # but add a link to catch any stragglers
    run "rm -rf #{release_path}/public/images/0000"
    run "ln -nfs ../system/images/0000 #{release_path}/public/images/0000"
  end
  after "deploy:update_code", "deploy:link_attachment_fu_dir"

  task :create_fck_files_dir do
    run "mkdir #{shared_path}/system/files"
    sudo "chown -R #{runner}:#{group} #{shared_path}/system/files"
    sudo "chmod g+ws #{shared_path}/system/files"
  end
  after "deploy:setup", "deploy:create_fck_files_dir"

  task :link_fck_files_dir do
    sudo "rm -rf #{release_path}/public/files"
    run "ln -nfs system/files #{release_path}/public"
  end
  after "deploy:update_code", "deploy:link_fck_files_dir"
end

#####################################################################

# we don't keep database.yml in subversion, so write one with capistrano
# http://shanesbrain.net/2007/5/30/managing-database-yml-with-capistrano-2-0
# see also:
# http://www.jvoorhis.com/articles/2006/07/07/managing-database-yml-with-capistrano
# http://jonathan.tron.name/articles/2006/07/15/capistrano-password-prompt-tips
set :db_adapter, "mysql"
set :db_socket, "/var/run/mysqld/mysqld.sock"
set :host, "192.168.0.162"
set :db_user, "#{application}"

before "deploy:setup", :db
after "deploy:update_code", "db:symlink"

require 'erb'
namespace :db do
  desc "Create database yaml in shared path"
  task :default do
    set :db_password, `/usr/bin/pwgen -1s 20` # FIXME: want to create user with this pw

    db_config = ERB.new <<-EOF
base: &base
  adapter: #{db_adapter}
  socket: #{db_socket}
  host: #{host}
  username: #{db_user}
  password: #{db_password}

development:
  #database: #{application}_development
  database: #{application}
  <<: *base

test:
  database: #{application}_test
  <<: *base

production:
  #database: #{application}_production
  database: #{application}
  <<: *base
EOF

    run "mkdir -p #{shared_path}/config"
    put db_config.result, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end
