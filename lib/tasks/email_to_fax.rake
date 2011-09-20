namespace :fax do
  desc "Pull email from POP3 account"
  task :pop3 => :environment do
    require 'pop3_pull'
    Pop3Pull.start()
  end
end
