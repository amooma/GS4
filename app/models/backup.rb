class Backup < ActiveRecord::Base
  attr_accessor :password
  attr_accessor :password_confirmation
  attr_accessor :backup_device
  validates_confirmation_of :password
  validates_format_of :password, :with => /^[0-9a-zA-Z]*$/, :allow_blank => true, :allow_nil => true
  validates_format_of :backup_device, :with => /^[a-z]{3}$/, :on => :create
  
  before_save(:on => :update) {
    require 'iconv'

    log_file = '/tmp/backup_system.log'
    if FileTest.exists?( log_file )
      log_data = File.read( log_file, nil, 0, {
        :external_encoding => Encoding::ISO_8859_1,
        :internal_encoding => Encoding::UTF_8,
        }
      )
    else
      log_data = ''
    end
    info = log_data.to_yaml  
  }
  after_create() {
     `sudo nohup /usr/local/bin/backup_system.sh "#{self.id}" "#{self.backup_device}" "#{self.password if ! self.password.empty?}" &`
  }
end
