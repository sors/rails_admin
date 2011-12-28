require File.expand_path('../../rails_admin/tasks/uninstall', __FILE__)
task :environment => :disable_rails_admin_initializer

task :disable_rails_admin_initializer do
  ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'true' if ENV['SKIP_RAILS_ADMIN_INITIALIZER'].nil?
end

namespace :rails_admin do
  desc "Uninstall rails_admin"
  task :uninstall do
    RailsAdmin::Tasks::Uninstall.run
  end
end
