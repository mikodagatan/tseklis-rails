# config valid only for current version of Capistrano
lock "3.9.1"

set :application, "tseklis"
set :repo_url, "git@bitbucket.org:kimonoso/tseklis-rails.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/tseklis"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5


append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"


namespace :rails do
  desc 'Open a rails console `cap [staging] rails:console [server_index default: 0]`'
  task :console do
    server = roles(:app)[ARGV[2].to_i]

    puts "Opening a console on: #{server.hostname}...."

    cmd = "ssh #{server.user}@#{server.hostname} -t 'cd #{fetch(:deploy_to)}/current && RAILS_ENV=#{fetch(:rails_env)} bundle exec rails console'"

    puts cmd

    exec cmd
  end


  set :rbenv_ruby, '2.4.0'

  # set the locations that we will look for changed assets to determine whether to precompile
  set :assets_dependencies, %w(app/assets lib/assets vendor/assets Gemfile.lock config/routes.rb)

  # clear the previous precompile task
  Rake::Task["deploy:assets:precompile"].clear_actions
  class PrecompileRequired < StandardError; end

  namespace :deploy do
    namespace :assets do
      desc "Precompile assets"
      task :precompile do
        on roles(fetch(:assets_roles)) do
          within release_path do
            with rails_env: fetch(:rails_env) do
              begin
                # find the most recent release
                latest_release = capture(:ls, '-xr', releases_path).split[1]

                # precompile if this is the first deploy
                raise PrecompileRequired unless latest_release

                latest_release_path = releases_path.join(latest_release)

                # precompile if the previous deploy failed to finish precompiling
                execute(:ls, latest_release_path.join('assets_manifest_backup')) rescue raise(PrecompileRequired)

                fetch(:assets_dependencies).each do |dep|
                  # execute raises if there is a diff
                  execute(:diff, '-Naur', release_path.join(dep), latest_release_path.join(dep)) rescue raise(PrecompileRequired)
                end

                info("Skipping asset precompile, no asset diff found")

                # copy over all of the assets from the last release
                execute(:cp, '-r', latest_release_path.join('public', fetch(:assets_prefix)), release_path.join('public', fetch(:assets_prefix)))
              rescue PrecompileRequired
                execute(:rake, "assets:precompile")
              end
            end
          end
        end
      end
    end
  end
end
