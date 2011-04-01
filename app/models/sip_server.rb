class SipServer < AServer
  
  has_many :sip_accounts, :dependent => :restrict
  
  attr_accessor :last_sip_server_id
  
  after_create {
    if self.last_sip_server_id
      sip_accounts = SipAccount.where( :sip_server_id => last_sip_server_id )
      sip_accounts.each { |sip_account|
        sip_account.update_attributes( :sip_server_id => self.id )
      }
    end
  }
  
  # TODO tests for last_sip_server_id
  
end
