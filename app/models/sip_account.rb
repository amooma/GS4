require 'connection_checks'

class SipAccount < ActiveRecord::Base
  
  include ConnectionChecks
  
  belongs_to :sip_server       , :validate => true
  belongs_to :sip_proxy        , :validate => true
  belongs_to :voicemail_server , :validate => true
  belongs_to :phone        , :validate => true
  belongs_to :extension        , :validate => true
  belongs_to :user             , :validate => true
  
  acts_as_list :scope => :user
  
  validate_username         :auth_name
  validates_uniqueness_of   :auth_name, :case_sensitive => false,  :scope => :sip_server_id
  
  validates_presence_of     :sip_server
  validates_presence_of     :sip_proxy
<<<<<<< HEAD
  validates_presence_of     :voicemail_server , :if => Proc.new { |me| me.voicemail_server_id }
  validates_presence_of     :sip_phone        , :if => Proc.new { |me| me.sip_phone_id }
  validates_presence_of     :extension        , :if => Proc.new { |me| me.extension_id }
  validates_presence_of     :user             , :if => Proc.new { |me| me.user_id }
=======
  validates_presence_of     :voicemail_server , :if => Proc.new { |sip_account| sip_account.voicemail_server_id }
  validates_presence_of     :phone        , :if => Proc.new { |sip_account| sip_account.phone_id }
  validates_presence_of     :extension        , :if => Proc.new { |sip_account| sip_account.extension_id }
  validates_presence_of     :user             , :if => Proc.new { |sip_account| sip_account.user_id }
>>>>>>> redesign
  
  validate_password         :password
  
  validates_presence_of     :phone_number
  validates_format_of       :phone_number, :with => /\A [1-9][0-9]{,9} \z/x,
    :allow_blank => false,
    :allow_nil   => false
  validates_numericality_of :phone_number, :greater_than_or_equal_to => 1
  
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
