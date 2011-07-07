class SipAccount < ActiveRecord::Base
  
  belongs_to :sip_server       , :validate => true
  belongs_to :sip_proxy        , :validate => true
  belongs_to :voicemail_server , :validate => true
  belongs_to :phone            , :validate => true
  belongs_to :user             , :validate => true
  has_many :call_forwards, :dependent => :destroy
  has_many :call_logs, :dependent => :destroy
  has_many :sip_account_to_extensions, :dependent => :destroy   #OPTIMIZE :order => 'position' ?
  has_many :extensions, :through => :sip_account_to_extensions  #OPTIMIZE :order => 'position' ?
  has_many :call_forwards, :dependent => :destroy
  acts_as_list :scope => :user
  
  validate_username         :auth_name
  validates_uniqueness_of   :auth_name, :case_sensitive => false, :scope => :sip_server_id
  # As long as caller_name stays here
  validates_presence_of     :caller_name
  validates_presence_of     :sip_server
  validates_presence_of     :sip_proxy
  validates_presence_of     :voicemail_server , :if => Proc.new { |me| me.voicemail_server_id }
  validates_presence_of     :phone            , :if => Proc.new { |me| me.phone_id }
  validates_presence_of     :user             , :if => Proc.new { |me| me.user_id }
  
  validate_password         :password
  
  validates_numericality_of :voicemail_pin,
    :if => Proc.new { |sip_account| ! sip_account.voicemail_server_id.blank? },
    :only_integer => true,
    :greater_than_or_equal_to => 1000,
    :message => I18n.t(:numeric_greater_than, :value => 1000)
  validates_inclusion_of    :voicemail_pin,
    :in => [ nil ],
    :if => Proc.new { |sip_account| sip_account.voicemail_server_id.blank? },
    :message => I18n.t(:must_not_be_set_if_no_voicemail_server)
  
  after_validation :phone_reboot
  before_destroy   :phone_reboot
  
  before_validation( :on => :update ) {
    if self.auth_name != self.auth_name_was
      errors.add( :auth_name, I18n.t(:cannot_be_changed) )
    end
  }
  
  before_validation {
    if self.phone_id
      if self.user_id != nil
        if  ! SipAccount.find(:all, :conditions => ['user_id != ? AND phone_id = ? ', "#{self.user_id}", "#{self.phone_id}"]).empty? ||
          ! SipAccount.where(:user_id => nil, :phone_id => self.phone_id).empty?
            errors.add( :base, I18n.t(:phone_belongs_to_user_allready) )
        end
      else
        if  ! SipAccount.find(:all, :conditions => ['user_id NOT ? AND phone_id = ?', nil, "#{self.phone_id}" ]).empty?
        errors.add( :base, I18n.t(:phone_belongs_to_user_allready) )
        end
        
      end
    end
  }
  
  after_validation( :on => :create ) {
    if (self.sip_server) \
    && (self.sip_proxy) \
    && (self.sip_proxy.is_local)  #FIXME self.sip_proxy can be nil (=> pko) - #OPTIMIZE @sd: Has this been resolved by 0cb666c2d61092e92a7b79e3a6e3fb148308dccc? See Message-ID: <4DED6A74.1070002@amooma.de>, Date: Tue, 07 Jun 2011 02:01:56 +0200
      create_subscriber()
    end
  }
  
  after_validation( :on => :update ) {
    if (self.sip_server) \
    && (self.sip_proxy) \
    && (self.sip_proxy.is_local)  #FIXME self.sip_proxy can be nil (=> pko) - #OPTIMIZE @sd: Has this been resolved by 0cb666c2d61092e92a7b79e3a6e3fb148308dccc? See Message-ID: <4DED6A74.1070002@amooma.de>, Date: Tue, 07 Jun 2011 02:01:56 +0200
      update_subscriber()
    else
      delete_subscriber()
    end
  }
  
  before_destroy {
    delete_subscriber()
  }
  
  #OPTIMIZE private ?
  
  def create_subscriber()
    subscriber = Subscriber.create(
      :username   =>  self.auth_name,
      :domain     =>  self.sip_server.host,
      :password   =>  self.password,
      :ha1        =>  Digest::MD5.hexdigest( "#{self.auth_name}:#{self.sip_server.host}:#{self.password}" )
    )
    if ! subscriber.valid?
      errors.add( :base, I18n.t(:subscriber_not_created))
    end
  end
  
  def update_subscriber()
    subscriber_update = Subscriber.find_by_username( self.auth_name_was )
    if (! subscriber_update.nil?)
      subscriber = subscriber_update.update_attributes(
        :username   =>  self.auth_name,
        :domain     =>  self.sip_server.host,
        :password   =>  self.password,
        :ha1        =>  Digest::MD5.hexdigest( "#{self.auth_name}:#{self.sip_server.host}:#{self.password}" )
      )
      if ! subscriber
        errors.add( :base, I18n.t(:subscriber_not_updated))
      end
    else
      create_subscriber()
    end
  end
  
  def delete_subscriber()
    if (! self.sip_proxy_id_was.nil?) \
    && (SipProxy.find_by_id( self.sip_proxy_id_was).is_local)  #FIXME self.sip_proxy can be nil (=> pko)
      subscriber_delete = Subscriber.find_by_username( self.auth_name_was )
      if subscriber_delete
        if ! subscriber_delete.destroy
          errors.add( :base, I18n.t(:subscriber_not_deleted))
        end
      end
    end
  end
  
  def phone_reboot
    self.phone.reboot if self.phone
  end
  
end
