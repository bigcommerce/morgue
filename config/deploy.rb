require 'capistrano/ext/multistage'

set :stages, %w(production)
set :default_stage, 'production'

set :application, 'morgue'
set :scm, :git
set :group_writeable, false
set :deploy_to, '/opt/morgue/'
set :copy_cache, false
set :deploy_via, :copy
set :branch, 'master'

set :keep_releases, 25
after 'deploy:update', 'deploy:cleanup'

# the following permits localhost deployments (vagrant) while also working in
# staging and prod, otherwise the copy src and dst are the same, causing an
# sftp error
require "tmpdir"
set :copy_dir, "#{Dir.tmpdir}/capistrano"

set :copy_exclude, [
  # Ignore Capistrano files
  'Capfile', 'config/deploy.rb', 'config/deploy/*.rb', 'config/lib',
  # Ignore Git files
  '.git',
  # Ignore development files
  'tests',
  # Ignore CI files
  '.travis.yml', '.travis.secret.enc', '.travis.key.enc',
]

if `uname` =~ /Darwin/
  # assumes osx users have gnu tools installed via something like brew
  # brew install findutils
  set :copy_local_tar, "/usr/bin/gnutar"
end

set :repository, '.'
set :build_script, 'composer -o --no-dev install'

# SSH Options
set :use_sudo, false
set :user,  'deploy_morgue'
set :group, 'deploy_morgue'

default_run_options[:pty]   = true
ssh_options[:forward_agent] = true
ssh_options[:keys]          = '/etc/deploy_keys/deploy-morgue-production.key'

after 'deploy:symlink', 'deploy:restart'

namespace :deploy do
  desc <<-DESC
    Reload apache after a successful deployment.
  DESC
  task :restart, :except => { :no_release => true } do
    run 'sudo /etc/init.d/apache2 reload'
  end
end
