namespace :db do
  task :appliance_seed => :environment do
    Configuration.create(:name => 'is_appliance', :value => 'true')
  end
end
