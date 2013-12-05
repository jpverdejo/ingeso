require "rvm/capistrano"
require 'bundler/capistrano'

set :application, "Ingeso"

set :user, 'deploy'
set :domain, 'deploy@162.243.251.125'
set :applicationdir, "/home/rails"
 
set :scm, 'git'
set :repository,  "git@github.com:jpverdejo/ingeso.git"
#set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, false
 
# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true
 
# deploy config
set :deploy_to, applicationdir
set :deploy_via, :export
 
# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
