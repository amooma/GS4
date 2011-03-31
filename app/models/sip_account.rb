class SipAccount < ActiveRecord::Base
  
  belongs_to :sip_server       , :validate => true
  belongs_to :sip_proxy        , :validate => true
  belongs_to :voicemail_server , :validate => true
  belongs_to :sip_phone        , :validate => true
  belongs_to :extension        , :validate => true
  belongs_to :user             , :validate => true
  
  acts_as_list :scope => :user
  
  validate_username         :auth_name
  validates_uniqueness_of   :auth_name, :scope => :sip_server_id
  
  validates_presence_of     :sip_server
  validates_presence_of     :sip_proxy
  validates_presence_of     :voicemail_server , :if => Proc.new { |sip_account| sip_account.voicemail_server_id }
  validates_presence_of     :sip_phone        , :if => Proc.new { |sip_account| sip_account.sip_phone_id }
  validates_presence_of     :extension        , :if => Proc.new { |sip_account| sip_account.extension_id }
  validates_presence_of     :user             , :if => Proc.new { |sip_account| sip_account.user_id }
    
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
  
  after_validation( :on => :create ) {
    if ! sip_phone_id.nil?
      provisioning_server_sip_account_create
    end
    
    if self.sip_server && ! self.sip_server.management_host.blank?
      if (self.sip_server_id != nil) \
      && (self.sip_proxy_id  != nil) \
      && (self.phone_number  != nil)
        sipproxy_user_create(  sip_server_id )
        sipproxy_alias_create( sip_server_id )
      end
    end
  }
  
  after_validation( :on => :update ) {
    provisioning_server_type = 'cantina'  # might want to implement a mock Cantina here
    
    need_to_delete_old_sip_acct = false
    if sip_phone_id_was != nil    # The SIP account was associated to a phone before.
      logger.debug "The SIP account had a phone."
      if sip_phone_id != sip_phone_id_was    # The phone is being changed.
        if sip_phone_id != nil
          phone_prov_server_id_was = SipPhone.find( sip_phone_id_was ).provisioning_server_id
          phone_prov_server_id_is  = SipPhone.find( sip_phone_id     ).provisioning_server_id
          if phone_prov_server_id_is != phone_prov_server_id_was
            # The SIP account is being associated to a phone on a different provisioning server instance.
            logger.debug "The SIP account is being associated to a phone on a different provisioning server instance."
            need_to_delete_old_sip_acct = true
          else
            logger.debug "The SIP account is being associated to a different phone on the same provisioning server instance."
          end
        else  # The SIP account is being associated to no phone.
          logger.debug "The SIP account is being associated to no phone."
          if provisioning_server_type == 'cantina'
            need_to_delete_old_sip_acct = true
          end
        end
      else
        logger.debug "The SIP account's phone isn't being changed."
      end
      if provisioning_server_type == 'cantina'
        if self.auth_name != self.auth_name_was
          # OPTIMIZE Can we just make an update?
          need_to_delete_old_sip_acct = true
        end
      end
    else
      logger.debug "The SIP account didn't have a phone."
    end
    
    if need_to_delete_old_sip_acct
      logger.debug "Deleting old SIP account on the provisioning server ..."
      provisioning_server_sip_account_destroy_old
    else
      logger.debug "No need to delete the old SIP account on the provisioning server."
    end
    
    if ! sip_phone_id.nil?
      provisioning_server_sip_account_update
    end
    
    if self.sip_server_id != self.sip_server_id_was
      if ! SipServer.find(self.sip_server_id_was).management_host.blank?
        sipproxy_user_destroy( sip_server_id_was, auth_name_was )
      end
    else
      # OPTIMIZE Only check if method has to be called. Method checks if server is managed or not.
      if ! self.sip_server.management_host.blank?
        if (self.auth_name    != self.auth_name_was    ) \
        || (self.password     != self.password_was     )
          sipproxy_user_update( sip_server_id, auth_name_was )
        end
        if (self.auth_name    != self.auth_name_was    ) \
        || (self.phone_number != self.phone_number_was )
          sipproxy_alias_update( self.sip_server_id, self.auth_name_was, self.phone_number_was )
        end
      end
    end
  }
  
  before_destroy {
    if ! sip_phone_id.nil?
      provisioning_server_sip_account_destroy
    end
    
    if ! sip_server_id.nil? && ! self.sip_server.management_host.blank?
      sipproxy_user_destroy(  self.sip_server_id_was, self.auth_name_was )
      sipproxy_alias_destroy( self.sip_server_id_was, self.auth_name_was, self.phone_number_was )
    end
  }
  
  
  # Returns the corresponding SIP account from Cantina.
  # Returns the CantinaSipAccount if found or nil if not found or
  # false on error.
  #
  def cantina_sip_account
    return cantina_sip_account_find_by_server_and_user(
      nil,
      self.sip_server ? self.sip_server.host : nil,
      self.auth_name
    )
  end
  
  
  private
  
  # Create SIP account on the provisioning server.
  #
  def provisioning_server_sip_account_create
    provisioning_server_type = 'cantina'  # might want to implement a mock Cantina here
    ret = false
    if self.errors && self.errors.length > 0
      # The SIP account is invalid. Don't even try to create it on the prov. server.
      errors.add( :base, "Will not create invalid SIP account on the provisioning server." )
    else
      case provisioning_server_type
        when 'cantina'
          ret = cantina_sip_account_create
        else
          errors.add( :base, "Provisioning server type #{provisioning_server_type.inspect} not implemented." )
      end
    end
    return ret
  end
  
  # Update SIP account on the provisioning server.
  #
  def provisioning_server_sip_account_update
    provisioning_server_type = 'cantina'  # might want to implement a mock Cantina here
    ret = false
    if self.errors && self.errors.length > 0
      # The SIP account is invalid. Don't even try to update it on the prov. server.
      errors.add( :base, "SIP account is invalid. Will not update data on the provisioning server." )
    else
      case provisioning_server_type
        when 'cantina'
          ret = cantina_sip_account_update
        else
          errors.add( :base, "Provisioning server type #{provisioning_server_type.inspect} not implemented." )
      end
    end
    return ret
  end
  
  # Delete SIP account on the provisioning server.
  #
  def provisioning_server_sip_account_destroy
    provisioning_server_type = 'cantina'  # might want to implement a mock Cantina here
    ret = false
    case provisioning_server_type
      when 'cantina'
        ret = cantina_sip_account_destroy
      else
        errors.add( :base, "Provisioning server type #{provisioning_server_type.inspect} not implemented." )
    end
    return ret
  end
  
  # Delete old SIP account on the provisioning server.
  #
  def provisioning_server_sip_account_destroy_old
    provisioning_server_type = 'cantina'  # might want to implement a mock Cantina here
    ret = false
    case provisioning_server_type
      when 'cantina'
        ret = cantina_sip_account_destroy_old
      else
        errors.add( :base, "Provisioning server type #{provisioning_server_type.inspect} not implemented." )
    end
    return ret
  end
  
  # Returns the appropriate "site" parameter URL to use for the
  # CantinaSipAccount ActiveResource. Returns nil if the SipPhone
  # corresponding to this SipAccount does not have provisioning
  # or if the SipAccount does not even have a SipPhone (and thus
  # does not have a provisioning server).
  # the_sip_phone_id can be nil to use the provisioning_server_id
  # of the account's current sip_phone, or you may want to pass in
  # sip_phone_id_was.
  #
  def provisioning_server_base_url( the_sip_phone_id=nil )
    scheme = 'http'
    host   = '0.0.0.0'  # this will not work on purpose
    port   = 0          # this will not work on purpose
    path   = '/'
    
    the_sip_phone_id = self.sip_phone_id if the_sip_phone_id == nil
    begin
      the_sip_phone = the_sip_phone_id ? SipPhone.find( the_sip_phone_id ) : nil
    rescue ActiveResource::ResourceNotFound => e
      the_sip_phone = nil
    end
    
    if the_sip_phone
      if the_sip_phone.provisioning_server_id.blank?
        logger.debug "SipPhone #{the_sip_phone_id.inspect} has no provisioning server. Alright."
        return nil  # phone without provisioning
      else
        the_prov_server = the_sip_phone.provisioning_server  # We're using a variable name different from the provisioning_server method.
        if the_prov_server
          scheme = 'http'  # TODO - https as soon as it is implemented.
          host   = the_prov_server.name if ! the_prov_server.name.blank?
          port   = the_prov_server.port if ! the_prov_server.port.blank?
          path   = '/'
        end
      end
    else
      logger.debug "SipAccount ID #{self.id} is not associated to a SipPhone, i.e. does not have a provisioning server."
      return nil  # SIP account without phone and thus without provisioning server
    end
    ret = '%s://%s%s%s' % [
      scheme,
      host,
      port.blank? ? '' : ":#{port.to_s}",
      path,
    ]
    logger.debug "SipPhone #{the_sip_phone_id.inspect} has prov. server #{ret.inspect}."
    return ret
  end
  
  # Find a SIP account by SIP server and SIP user on the Cantina
  # provisioning server.
  # Returns the CantinaSipAccount if found or nil if not found or
  # false on error.
  #
  def cantina_sip_account_find_by_server_and_user( the_sip_phone_id=nil, sip_server, sip_user )
    logger.debug "Trying to find Cantina SIP account for \"#{sip_user}@#{sip_server}\" ..."
    begin
      cantina_resource = provisioning_server_base_url( the_sip_phone_id )
      if ! cantina_resource
        # SipPhone has no provisioning server.
        return nil
      else
        CantinaSipAccount.set_resource( cantina_resource )
        cantina_sip_accounts = CantinaSipAccount.find( :all,
          :params => { 'auth_user' => sip_user.to_s })
        # => GET "/sip_accounts.xml?auth_user=#{sip_user}"
        # By passing the username parameter to Cantina we have
        # already narrowed the result, but we still need to check if
        # the SIP server matches. And while we're at it we can also
        # check the username, just to make sure.
        if cantina_sip_accounts
          cantina_sip_accounts.each { |cantina_sip_account|
            logger.debug "-------------{"
            logger.debug cantina_sip_account.inspect
            logger.debug "-------------}"
            if (cantina_sip_account.registrar .to_s == sip_server .to_s) \
            && (cantina_sip_account.user      .to_s == sip_user   .to_s)
              logger.debug "Found CantinaSipAccount ID #{cantina_sip_account.id}."
              return cantina_sip_account
              break
            end
          }
        end
        logger.debug "CantinaSipAccount for \"#{sip_user}@#{sip_server}\" not found."
        return nil
      end
    rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL, Errno::EHOSTDOWN, ActiveResource::TimeoutError => e
      logger.warn "Failed to connect to Cantina provisioning server at #{cantina_resource.inspect}. (#{e.class}, #{e.message})"
      return false
    end
  end
  
  # Create SIP account on the Cantina provisioning server.
  #
  def cantina_sip_account_create
    begin
      cantina_resource = provisioning_server_base_url()
      if ! cantina_resource
        return true
      else
        CantinaSipAccount.set_resource( cantina_resource )
        cantina_sip_account = CantinaSipAccount.create({
          :name            => "a SIP account from Gemeinschaft (#{Time.now.to_i}-#{self.object_id})",
          :auth_user       => self.auth_name,
          :user            => self.auth_name,
          :password        => self.password,
          :realm           => self.realm,
          :phone_id        => (self.sip_phone ? self.sip_phone.phone_id : nil),
          :registrar       => (self.sip_server ? self.sip_server.host : nil),
          :registrar_port  => nil,
          :sip_proxy       => (self.sip_proxy ? self.sip_proxy.host : nil),
          :sip_proxy_port  => nil,
          :outbound_proxy  => (self.sip_proxy ? self.sip_proxy.host : nil),
          :outbound_proxy_port => nil,
          :registration_expiry_time => 300,
          :dtmf_mode       => 'rfc2833',
        })
        active_record_errors_from_remote_log( cantina_sip_account )
        return true
      end
    rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL, Errno::EHOSTDOWN, ActiveResource::TimeoutError => e
      logger.warn "Failed to connect to Cantina provisioning server at #{cantina_resource.inspect}. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to Cantina provisioning server." )
      return false
    end
    
    if ! cantina_sip_account.valid?
      errors.add( :base, "Failed to create SIP account on Cantina provisioning server. (Reason:\n" +
        active_record_errors_from_remote_get( cantina_sip_account ).join(",\n") +
        ")" )
      return false
    end
  end
  
  # Update SIP account on the Cantina provisioning server.
  #
  def cantina_sip_account_update
    sip_server_was = self.sip_server_id_was ? SipServer.find( self.sip_server_id_was ) : nil
    cantina_sip_account = cantina_sip_account_find_by_server_and_user(
      nil,
      (sip_server_was ? sip_server_was.host : nil),
      self.auth_name_was
    )
    case cantina_sip_account
      when false
        errors.add( :base, "Failed to connect to Cantina provisioning server." )
        return false
      when nil
        # create instead
        return cantina_sip_account_create
      else
        if ! cantina_sip_account.update_attributes({
          :auth_user       => self.auth_name,
          :user            => self.auth_name,
          :password        => self.password,
          :realm           => self.realm,
          :phone_id        => (self.sip_phone ? self.sip_phone.phone_id : nil),
          :registrar       => (self.sip_server ? self.sip_server.host : nil),
          :registrar_port  => nil,
          :sip_proxy       => (self.sip_proxy ? self.sip_proxy.host : nil),
          :sip_proxy_port  => nil,
          :outbound_proxy  => (self.sip_proxy ? self.sip_proxy.host : nil),
          :outbound_proxy_port => nil,
          :registration_expiry_time => 300,
          :dtmf_mode       => 'rfc2833',
        })
          active_record_errors_from_remote_log( cantina_sip_account )
          errors.add( :base, "Failed to update SIP account on Cantina provisioning server. (Reason:\n" +
            active_record_errors_from_remote_get( cantina_sip_account ).join(",\n") +
            ")" )
          return false
        end
      #end else
    end
    return true
  end
  
  # Delete SIP account on the Cantina provisioning server.
  #
  def cantina_sip_account_destroy
    sip_server_was = self.sip_server_id_was ? SipServer.find( self.sip_server_id_was ) : nil
    cantina_sip_account = cantina_sip_account_find_by_server_and_user(
      nil,
      (sip_server_was ? sip_server_was.host : nil),
      self.auth_name_was
    )
    case cantina_sip_account
      when false
        errors.add( :base, "Failed to connect to Cantina provisioning server." )
        return false
      when nil
        # no action required
      else
        if ! cantina_sip_account.destroy
          errors.add( :base, "Failed to delete SIP account on Cantina provisioning server. (Reason:\n" +
            active_record_errors_from_remote_get( cantina_sip_account ).join(",\n") +
            ")" )
          return false
        end
      #end else
    end
    return true
  end
  
  # Delete old SIP account on the Cantina provisioning server.
  #
  def cantina_sip_account_destroy_old
    sip_server_was = self.sip_server_id_was ? SipServer.find( self.sip_server_id_was ) : nil
    delete_cantina_sip_account = cantina_sip_account_find_by_server_and_user(
      sip_phone_id_was,  # Find SIP account on the *old* provisioning server.
      (sip_server_was ? sip_server_was.host : nil),
      self.auth_name_was
    )
    logger.debug "delete_cantina_sip_account.id = #{(delete_cantina_sip_account ? delete_cantina_sip_account.id : nil).inspect}"
    if delete_cantina_sip_account
      if ! delete_cantina_sip_account.destroy
        errors.add( :base, "Failed to delete SIP account on Cantina provisioning server. (Reason:\n" +
          active_record_errors_from_remote_get( delete_cantina_sip_account ).join(",\n") +
          ")" )
        return false
      end
    end
    return true
  end
  
  # Create user on "SipProxy" proxy manager.
  #
  def sipproxy_user_create( proxy_server_id )
    server = SipServer.find( proxy_server_id )
    if server.management_host.blank?
      errors.add( :name, "is not managed by GS!")
      return false
    else
      SipproxySubscriber.set_resource( "http://#{server.management_host}:#{server.management_port}/" )
      sipproxy_subscriber = SipproxySubscriber.create(
        :username   =>  self.auth_name,
        :domain     =>  self.sip_server.host,
        :password   =>  self.password,
        :ha1        =>  Digest::MD5.hexdigest( "#{self.auth_name}:#{self.sip_server.host}:#{self.password}" )
      )
      if ! sipproxy_subscriber.valid?
        errors.add( :base, "Failed to create user account on SipProxy management server. (Reason:\n" +
        active_record_errors_from_remote_get( sipproxy_subscriber ).join(",\n") +
          ")" )
      end
    end
  end
  
  # Delete user on "SipProxy" proxy manager.
  #
  def sipproxy_user_destroy( proxy_server_id, proxy_server_authname )
    begin
      server = SipServer.find( proxy_server_id )
      if server.management_host.blank?
        errors.add( :name, "is not managed by GS!")
        return false
      else
        SipproxySubscriber.set_resource( "http://#{server.management_host}:#{server.management_port}/" )
        destroy_subscriber = SipproxySubscriber.find( :first, :params => { 'username' => proxy_server_authname.to_s })
        if ! destroy_subscriber.destroy
          errors.add( :base, "Failed to destroy user account on SipProxy management server. (Reason:\n" +
          active_record_errors_from_remote_get( sipproxy_subscriber ).join(",\n") +
            ")" )
        else
          return true
        end
      end
    rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL, Errno::EHOSTDOWN, ActiveResource::TimeoutError => e
      logger.warn "Failed to connect to SipProxy management server. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to SipProxy management server." )
      return false
    end
  end
  
  # Update user on "SipProxy" proxy manager.
  #
  def sipproxy_user_update( proxy_server_id, proxy_server_authname )
    server = SipServer.find( proxy_server_id )
    if server.management_host.blank?
      # TODO errormessage
      return false  # return true?
    else
      SipproxySubscriber.set_resource( "http://#{server.management_host}:#{server.management_port}/" )
      update_subscriber = SipproxySubscriber.find( :first, :params => { 'username' => proxy_server_authname.to_s })
      #FIXME - Catch exceptions by connection errors, see cantina_sip_account_update().
      case update_subscriber
        #when false
        #  errors.add( :base, "Failed to connect to SipProxy management server." )
        #  return false
        when nil
          # create instead
          return sipproxy_user_create( proxy_server_id )
        else
          if ! update_subscriber.update_attributes({
            :username   =>  self.auth_name,
            :domain     =>  self.sip_server.host,
            :password   =>  self.password,
            :ha1        =>  Digest::MD5.hexdigest( "#{self.auth_name}:#{self.sip_server.host}:#{self.password}" )
          })
            active_record_errors_from_remote_log( update_subscriber )
            errors.add( :base, "Failed to update user account on SipProxy management server. (Reason:\n" +
              active_record_errors_from_remote_get( update_subscriber ).join(",\n") +
              ")" )
            return false
          end
        #end else
      end
      return true
    end
  end
  
  # Create alias on "SipProxy" proxy manager.
  #
  def sipproxy_alias_create( proxy_server_id )
    server = SipServer.find( proxy_server_id )
    if server.management_host.blank?
      errors.add( :name, "is not managed by GS!")
      return false
    else
      SipproxyDbalias.set_resource( "http://#{server.management_host}:#{server.management_port}/" )
      sipproxy_dbalias = SipproxyDbalias.create(
        :username       =>  self.auth_name,
        :domain         =>  self.sip_server.host,
        :alias_username =>  self.phone_number,
        :alias_domain   =>  self.sip_server.host
      )
      if ! sipproxy_dbalias.valid?
        errors.add( :base, "Failed to create alias on SipProxy management server. (Reason:\n" +
        active_record_errors_from_remote_get( sipproxy_dbalias ).join(",\n") +
          ")" )
      end
    end
  end
  
  # Update alias on "SipProxy" proxy manager.
  #
  def sipproxy_alias_update( proxy_server_id, proxy_server_authname, proxy_server_alias )
    server = SipServer.find( proxy_server_id )
    if server.management_host.blank?
      # TODO errormessage
      return false  # return true?
    else
      SipproxyDbalias.set_resource( "http://#{server.management_host}:#{server.management_port}/" )
      update_dbalias = SipproxyDbalias.find( :first, :params => {'username'=> "#{proxy_server_authname}", 'alias_username' => "#{proxy_server_alias}"} )
      #FIXME - Catch exceptions by connection errors, see cantina_sip_account_update().
      case update_dbalias
        #when false
        #  errors.add( :base, "Failed to connect to SipProxy management server." )
        #  return false
        when nil
          # create instead
          return sipproxy_alias_create( proxy_server_id )
        else
          if ! update_dbalias.update_attributes({
            :username       =>  self.auth_name,
            :domain         =>  self.sip_server.host,
            :alias_username =>  self.phone_number,
            :alias_domain   =>  self.sip_server.host
          })
            active_record_errors_from_remote_log( update_dbalias )
            errors.add( :base, "Failed to update dbalias on SipProxy management server. (Reason:\n" +
              active_record_errors_from_remote_get( update_dbalias ).join(",\n") +
              ")" )
            return false
          end
        #end else
      end
      return true
    end
  end
  
  # Delete dbalias on "SipProxy" proxy manager.
  #
  def sipproxy_alias_destroy( proxy_server_id, proxy_server_authname, proxy_server_alias )
    begin
      server = SipServer.find( proxy_server_id )
      if server.management_host.blank?
        errors.add( :name, "is not managed by GS!" )
        return false
      else
        SipproxyDbalias.set_resource( "http://#{server.management_host}:#{server.management_port}/" )
        destroy_dbalias = SipproxyDbalias.find( :first, :params => { 'username' => proxy_server_authname.to_s, 'alias_username' => proxy_server_alias.to_s })
        if ! destroy_dbalias.destroy
          errors.add( :base, "Failed to destroy dbalias on SipProxy management server. (Reason:\n" +
          active_record_errors_from_remote_get( sipproxy_dbalias ).join(",\n") +
            ")" )
        else
          return true
        end
      end
    rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL, Errno::EHOSTDOWN, ActiveResource::TimeoutError => e
      logger.warn "Failed to connect to SipProxy management server. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to SipProxy management server." )
      return false
    end
  end
  
  # Log validation errors from the remote model.
  #
  def active_record_errors_from_remote_log( ar )
    if ar.respond_to?(:errors) && ar.errors.kind_of?(Hash)
      if ar.errors.length < 1
        logger.info "No errors for #{ar.class} from remote."
      else
        logger.info "----------------------------------------------------------"
        logger.info "Errors for #{ar.class} from remote:"
        ar.errors.each_pair { |attr, errs|
          logger.info "  :#{attr.to_s}"
          if errs.kind_of?(Array) && errs.length > 0
            errs.each { |msg|
              logger.info "    " + (attr == :base ? '' : ":#{attr.to_s} ") + "#{msg}"
            }
          end
        }
        logger.info "----------------------------------------------------------"
      end
    end
  end
  
  # Get validation errors from the remote model.
  #
  def active_record_errors_from_remote_get( ar )
    ret = []
    if ar.respond_to?(:errors) && ar.errors.kind_of?(Hash)
      ar.errors.each_pair { |attr, errs|
        if errs.kind_of?(Array) && errs.length > 0
          errs.each { |msg|
            ret << ( '' + (attr == :base ? '' : "#{attr.to_s} ") + "#{msg}" )
          }
        end
      }
    end
    return ret
  end
  
end
