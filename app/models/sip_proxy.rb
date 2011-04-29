class SipProxy < AServer
  
  has_many :sip_accounts, :dependent => :restrict
  
  validates_uniqueness_of :host

  attr_accessor :last_sip_proxy_id
  
  after_create {
    if self.last_sip_proxy_id
      sip_accounts = SipAccount.where( :sip_proxy_id => last_sip_proxy_id )
      sip_accounts.each { |sip_account|
        sip_account.update_attributes( :sip_proxy_id => self.id )
      }
    end
  }
  
end
