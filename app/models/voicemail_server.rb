class VoicemailServer < AServer
  
  has_many :sip_accounts, :dependent => :nullify
    
  #TODO implement last_voicemail_server_id, see SipServer / SipProxy
  #attr_accessor :last_voicemail_server_id
  #
  #after_create {
  #  if self.last_voicemail_server_id
  #    sip_accounts = SipAccount.where( :voicemail_server_id => last_voicemail_server_id )
  #    sip_accounts.each { |sip_account|
  #      sip_account.update_attributes( :voicemail_server_id => self.id )
  #    }
  #  end
  #}
  #
  ## TODO tests for last_voicemail_server_id
  
end
