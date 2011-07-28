namespace :db do
  task :appliance_seed => :environment do
    ip_address = "192.168.254.254"
    servers = [ 'SipServer', 'SipProxy', 'VoicemailServer']
    servers.each do |server|
      server.constantize.create(:host => ip_address, :is_local => true) 
    end
  end
end
