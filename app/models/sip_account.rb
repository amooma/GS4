class SipAccount < ActiveRecord::Base
  
  #TODO Remove extension_id from sip_accounts database table.
  
  belongs_to :sip_server       , :validate => true
  belongs_to :sip_proxy        , :validate => true
  belongs_to :voicemail_server , :validate => true
  belongs_to :phone            , :validate => true
  belongs_to :user             , :validate => true
  
  has_many :sip_account_to_extensions, :dependent => :destroy
  has_many :extensions, :through => :sip_account_to_extensions
  
  acts_as_list :scope => :user
  
  validate_username         :auth_name
  validates_uniqueness_of   :auth_name, :case_sensitive => false, :scope => :sip_server_id
  
  validates_presence_of     :sip_server
  validates_presence_of     :sip_proxy
  validates_presence_of     :voicemail_server , :if => Proc.new { |me| me.voicemail_server_id }
  validates_presence_of     :phone            , :if => Proc.new { |me| me.phone_id }
  validates_presence_of     :extension        , :if => Proc.new { |me| me.extension_id }
  validates_presence_of     :user             , :if => Proc.new { |me| me.user_id }
  
  validate_password         :password
  
    
  validates_numericality_of :voicemail_pin,
    :if => Proc.new { |sip_account| ! sip_account.voicemail_server_id.blank? },
    :only_integer => true,
    :greater_than_or_equal_to => 1000,
    :message => "must be all digits and greater than 1000"
  validates_inclusion_of    :voicemail_pin,
    :in => [ nil ],
    :if => Proc.new { |sip_account| sip_account.voicemail_server_id.blank? },
    :message => "must not be set if the SIP account does not have a voicemail server."
  
end
