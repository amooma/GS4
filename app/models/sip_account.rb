# == Schema Information
# Schema version: 20110314104017
#
# Table name: sip_accounts
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  auth_name     :string(255)
#  password      :string(255)
#  realm         :string(255)
#  phone_number  :integer
#  sip_server_id :integer
#  sip_proxy_id  :integer
#  created_at    :datetime
#  updated_at    :datetime
#  extension_id  :integer
#  sip_phone_id  :integer
#  voicemail_pin :integer
#

class SipAccount < ActiveRecord::Base
  
  belongs_to :sip_server , :validate => true
  belongs_to :sip_proxy  , :validate => true
  belongs_to :sip_phone  , :validate => true
  belongs_to :extension  , :validate => true
  belongs_to :user
  
  #FIXME - validate that the referenced objects (*_id) exists
  
  validates_uniqueness_of   :auth_name, :scope => :sip_server_id
  validates_presence_of     :sip_server_id
  validates_presence_of     :sip_proxy_id
  validates_presence_of     :phone_number
  validate_username         :auth_name
  validate_password         :password
  validates_format_of       :phone_number, :with => /\A [1-9][0-9]{,9} \z/x,
    :allow_blank => false,
    :allow_nil => false
  validates_numericality_of :phone_number, :greater_than_or_equal_to => 1
  
  validates_numericality_of(:voicemail_pin,
    :greater_than_or_equal_to => 1000
  )
  
  
  after_validation( :on => :create ) do  #FIXME ? - Is this the correct callback so the handlers can abort the transaction by returning false? It used to be a different callback.
    if ! sip_phone_id.nil?
      provisioning_server_sip_account_create
    end
    if (! sip_server_id.nil?) && (! self.phone_number.nil?) && (! self.sip_proxy_id.nil?)  # ?
      if ! self.sip_server.config_port.nil?
        create_user_on_sipproxy(  sip_server_id )
        create_alias_on_sipproxy( sip_server_id )
      end
    end
  end
  
  after_validation( :on => :update ) do  #FIXME ? - Is this the correct callback so the handlers can abort the transaction by returning false? It used to be a different callback.
    if ! sip_phone_id.nil?
      provisioning_server_sip_account_update
    end
    if ((self.auth_name != self.auth_name_was && sip_phone_id_was != nil ) || (sip_phone_id_was != nil \
        && sip_phone_id != sip_phone_id_was))
      delete_last_cantina_account
    end
    if (((self.auth_name_was != self.auth_name) || (self.password != self.password_was)) && self.sip_server_id == self.sip_server_id_was && self.sip_server.config_port != nil)
      update_user_on_sipproxy( sip_server_id, auth_name_was )
    end
    #FIXME - self.sip_server can be nil
    if self.sip_server_id != self.sip_server_id_was && ! self.sip_server.config_port.nil?
      destroy_user_on_sipproxy( sip_server_id_was, auth_name_was )
    end
    if ((self.sip_server_id_was == self.sip_server_id) && \
        ((self.auth_name != self.auth_name_was) || (self.phone_number != self.phone_number_was)))
      update_alias_on_sipproxy( self.sip_server_id, self.auth_name_was, self.phone_number_was )
    end
  end
  
  before_destroy do  #FIXME ? - Is this the correct callback so the handlers can abort the transaction by returning false? It used to be a different callback.
    if ! sip_phone_id.nil?
      provisioning_server_sip_account_destroy
    end
    if ! sip_server_id.nil?
      if ! self.sip_server.config_port.nil?
        destroy_user_on_sipproxy(    self.sip_server_id_was, self.auth_name_was )
        destroy_dbalias_on_sipproxy( self.sip_server_id_was, self.auth_name_was, self.phone_number_was )
      end
    end
  end
  
  
  # Returns the corresponding SIP account from Cantina.
  # Returns the CantinaSipAccount if found or nil if not found or
  # false on error.
  #
  def cantina_sip_account
    return cantina_find_sip_account_by_server_and_user(
      self.sip_server ? self.sip_server.name : nil,
      self.auth_name
    )
  end
  
  private
  
  # Create SIP account on the provisioning server.
  #
  def provisioning_server_sip_account_create
    provisioning_server = 'cantina'  # might want to implement a mock Cantina here or multiple Cantinas
    ret = false
    if self.errors && self.errors.length > 0
      # The SIP account is invalid. Don't even try to create it on the prov. server.
      errors.add( :base, "Will not create invalid SIP account on the provisioning server." )
    else
      case provisioning_server
        when 'cantina'
          ret = cantina_sip_account_create
        else
          errors.add( :base, "Provisioning server type #{provisioning_server.inspect} not implemented." )
      end
    end
    return ret
  end
  
  # Update SIP account on the provisioning server.
  #
  def provisioning_server_sip_account_update
    provisioning_server = 'cantina'  # might want to implement a mock Cantina here or multiple Cantinas
    ret = false
    if self.errors && self.errors.length > 0
      # The SIP account is invalid. Don't even try to update it on the prov. server.
      errors.add( :base, "SIP account is invalid. Will not update data on the provisioning server." )
    else
      case provisioning_server
        when 'cantina'
          ret = cantina_sip_account_update
        else
          errors.add( :base, "Provisioning server type #{provisioning_server.inspect} not implemented." )
      end
    end
    return ret
  end
  
  # Delete SIP account on the provisioning server.
  #
  def provisioning_server_sip_account_destroy
    provisioning_server = 'cantina'  # might want to implement a mock Cantina here or multiple Cantinas
    ret = false
    case provisioning_server
      when 'cantina'
        ret = cantina_sip_account_destroy
      else
        errors.add( :base, "Provisioning server type #{provisioning_server.inspect} not implemented." )
    end
    return ret
  end
  
  # Returns the appropriate "site" parameter URL to use for the
  # CantinaSipAccount ActiveResource. Returns nil if the SipPhone
  # corresponding to this SipAccount does not have provisioning
  # or if the SipAccount does not even have a SipPhone (and thus
  # does not have a provisioning server).
  #
  def determine_prov_server_resource
    scheme = 'http'
    host   = '0.0.0.0'  # this will not work on purpose
    port   = 0          # this will not work on purpose
    path   = '/'
    if self.sip_phone
      if self.sip_phone.provisioning_server_id.blank?
        logger.debug "SipPhone #{self.sip_phone_id.inspect} has no provisioning server. Alright."
        return nil  # phone without provisioning
      else
        provisioning_server = self.sip_phone.provisioning_server
        if provisioning_server
          scheme = 'http'  # TODO - https as soon as it is implemented.
          host   = provisioning_server.name if ! provisioning_server.name.blank?
          port   = provisioning_server.port if ! provisioning_server.port.blank?
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
    logger.debug "SipPhone #{self.sip_phone_id.inspect} has prov. server #{ret.inspect}."
    return ret
  end
  
  # Find a SIP account by SIP server and SIP user on the Cantina
  # provisioning server.
  # Returns the CantinaSipAccount if found or nil if not found or
  # false on error.
  #
  def cantina_find_sip_account_by_server_and_user( sip_server, sip_user )
    logger.debug "Trying to find Cantina SIP account for \"#{sip_user}@#{sip_server}\" ..."
    begin
      cantina_resource = determine_prov_server_resource()
      if ! cantina_resource
        # SipPhone has no provisioning server.
        return nil
      else
        CantinaSipAccount.set_resource( cantina_resource )
        cantina_sip_accounts = CantinaSipAccount.all()
        # GET "/sip_accounts.xml" - #OPTIMIZE - The Cantina API does not let us do more advanced queries so we have to get all SIP accounts.
        # As soon as the Cantina API has been extended please optimize this method. Thanks.
        if cantina_sip_accounts
          cantina_sip_accounts.each { |cantina_sip_account|
            if (cantina_sip_account.registrar .to_s == sip_server .to_s) \
            && (cantina_sip_account.auth_user .to_s == auth_name  .to_s)
              logger.debug "Found CantinaSipAccount ID #{cantina_sip_account.id}."
              return cantina_sip_account
              break
            end
          }
        end
        logger.debug "CantinaSipAccount not found."
        return nil
      end
    rescue Errno::ECONNREFUSED => e
      logger.warn "Failed to connect to Cantina provisioning server at #{cantina_resource.inspect}. (#{e.class}, #{e.message})"
      return false
    rescue Errno::EADDRNOTAVAIL => e
      logger.warn "Failed to connect to Cantina provisioning server at #{cantina_resource.inspect}. (#{e.class}, #{e.message})"
      return false
    rescue Errno::EHOSTDOWN => e
      logger.warn "Failed to connect to Cantina provisioning server at #{cantina_resource.inspect}. (#{e.class}, #{e.message})"
      return false
    end
  end
  
  # Create SIP account on the Cantina provisioning server.
  #
  def cantina_sip_account_create
    begin
      cantina_resource = determine_prov_server_resource()
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
          :registrar       => (self.sip_server ? self.sip_server.name : nil),
          :registrar_port  => nil,
          :sip_proxy       => (self.sip_proxy ? self.sip_proxy.name : nil),
          :sip_proxy_port  => nil,
          :registration_expiry_time => 300,
          :dtmf_mode       => 'rfc2833',
        })
        log_active_record_errors_from_remote( cantina_sip_account )
        return true
      end
    rescue Errno::ECONNREFUSED => e
      logger.warn "Failed to connect to Cantina provisioning server at #{cantina_resource.inspect}. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to Cantina provisioning server." )
      return false
    rescue Errno::EADDRNOTAVAIL => e
      logger.warn "Failed to connect to Cantina provisioning server at #{cantina_resource.inspect}. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to Cantina provisioning server." )
      return false
    rescue Errno::EHOSTDOWN => e
      logger.warn "Failed to connect to Cantina provisioning server at #{cantina_resource.inspect}. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to Cantina provisioning server." )
      return false
    end
    
    if ! cantina_sip_account.valid?
      errors.add( :base, "Failed to create SIP account on Cantina provisioning server. (Reason:\n" +
      get_active_record_errors_from_remote( cantina_sip_account ).join(",\n") +
        ")" )
      return false
    end
  end
  
  # Update SIP account on the Cantina provisioning server.
  #
  def cantina_sip_account_update
    sip_server_was = self.sip_server_id_was ? SipServer.find( self.sip_server_id_was ) : nil
    cantina_sip_account = cantina_find_sip_account_by_server_and_user(
      (sip_server_was ? sip_server_was.name : nil),
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
          :registrar       => (self.sip_server ? self.sip_server.name : nil),
          :registrar_port  => nil,
          :sip_proxy       => (self.sip_proxy ? self.sip_proxy.name : nil),
          :sip_proxy_port  => nil,
          :registration_expiry_time => 300,
          :dtmf_mode       => 'rfc2833',
        })
          log_active_record_errors_from_remote( cantina_sip_account )
          errors.add( :base, "Failed to update SIP account on Cantina provisioning server. (Reason:\n" +
          get_active_record_errors_from_remote( cantina_sip_account ).join(",\n") +
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
    cantina_sip_account = cantina_find_sip_account_by_server_and_user(
      (sip_server_was ? sip_server_was.name : nil),
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
          get_active_record_errors_from_remote( cantina_sip_account ).join(",\n") +
            ")" )
          return false
        end
    end
    return true
  end
  
  # Delete SipAccount on Cantina when Phone has changed.
  #
  def delete_last_cantina_account
    old_prov_server = SipPhone.find(sip_phone_id_was).provisioning_server
    if ! old_prov_server.blank?
      CantinaSipAccount.set_resource( "http://#{old_prov_server.name}:#{old_prov_server.port}/" )
      cantina_sip_accounts = CantinaSipAccount.all
      if cantina_sip_accounts
        matching_cantina_sip_accounts = cantina_sip_accounts.each { |cantina_sip_account|
          if (cantina_sip_account.registrar .to_s == self.sip_server .to_s) \
          && (cantina_sip_account.auth_user .to_s == self.auth_name  .to_s)
            logger.debug "Found CantinaSipAccount ID #{cantina_sip_account.id}."
            #FIXME ? - Does this block really do anything?
            break
          end
        }
        #puts "matching_cantina_sip_accounts = #{matching_cantina_sip_accounts.inspect}"
        delete_cantina_sip_account_id = matching_cantina_sip_accounts.collect {|a| a.id}.to_enum.first
        logger.debug "delete_cantina_sip_account_id = #{delete_cantina_sip_account_id.inspect}"
        if delete_cantina_sip_account_id
          if ! CantinaSipAccount.find( delete_cantina_sip_account_id ).destroy
            errors.add( :base, "Failed to delete SIP account on Cantina provisioning server. (Reason:\n" +
            get_active_record_errors_from_remote( delete_cantina_sip_account_id ).join(",\n") +
              ")" )
          end
        end
      end
    end
  end
  
  # Create user on "SipProxy" proxy manager.
  #
  def create_user_on_sipproxy( proxy_server_id )
    server = SipServer.find(proxy_server_id)
    if server.config_port.nil?
      # TODO errormessage
      return false
    else
      SipproxySubscriber.set_resource( "http://#{server.name}:#{server.config_port}/" )
      sipproxy_subscriber = SipproxySubscriber.create(
        :username   =>  self.auth_name,
        :domain     =>  self.sip_server.name,
        :password   =>  self.password,
        :ha1        =>  Digest::MD5.hexdigest( "#{self.auth_name}:#{self.sip_server.name}:#{self.password}" )
      )
      if ! sipproxy_subscriber.valid?
        errors.add( :base, "Failed to create user account on SipProxy management server. (Reason:\n" +
        get_active_record_errors_from_remote( sipproxy_subscriber ).join(",\n") +
          ")" )
      end
    end
  end
  
  # Delete user on "SipProxy" proxy manager.
  #
  def destroy_user_on_sipproxy( proxy_server_id, proxy_server_authname )
    begin
      server = SipServer.find(proxy_server_id)
      if server.config_port.nil?
        # TODO errormessage
        return false
      else
        SipproxySubscriber.set_resource( "http://#{server.name}:#{server.config_port}/" )
        destroy_subscriber = SipproxySubscriber.find( :first, :params => { 'username' => proxy_server_authname.to_s })
        if ! destroy_subscriber.destroy
          errors.add( :base, "Failed to destroy user account on SipProxy management server. (Reason:\n" +
          get_active_record_errors_from_remote( sipproxy_subscriber ).join(",\n") +
            ")" )
        else
          return true
        end
      end
    rescue Errno::ECONNREFUSED => e
      logger.warn "Failed to connect to SipProxy management server. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to SipProxy management server." )
      return false
    rescue Errno::EADDRNOTAVAIL => e
      logger.warn "Failed to connect to SipProxy management server. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to SipProxy management server." )
      return false
    rescue Errno::EHOSTDOWN => e
      logger.warn "Failed to connect to SipProxy management server. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to SipProxy management server." )
      return false
    end
  end
  
  # Update user on "SipProxy" proxy manager.
  #
  def update_user_on_sipproxy( proxy_server_id, proxy_server_authname )
    server = SipServer.find( proxy_server_id )
    if server.config_port.blank?
      # TODO errormessage
      return false  # return true?
    else
      SipproxySubscriber.set_resource( "http://#{server.name}:#{server.config_port}/" )
      update_subscriber = SipproxySubscriber.find( :first, :params => { 'username' => proxy_server_authname.to_s })
      #FIXME - Catch exceptions by connection errors, see cantina_sip_account_update().
      case update_subscriber
        #when false
        #  errors.add( :base, "Failed to connect to SipProxy management server." )
        #  return false
        when nil
          # create instead
          return create_user_on_sipproxy( proxy_server_id )
        else
          if ! update_subscriber.update_attributes({
            :username   =>  self.auth_name,
            :domain     =>  self.sip_server.name,
            :password   =>  self.password,
            :ha1        =>  Digest::MD5.hexdigest( "#{self.auth_name}:#{self.sip_server.name}:#{self.password}" )
          })
            log_active_record_errors_from_remote( update_subscriber )
            errors.add( :base, "Failed to update user account on SipProxy management server. (Reason:\n" +
            get_active_record_errors_from_remote( update_subscriber ).join(",\n") +
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
  def create_alias_on_sipproxy( proxy_server_id )
    server = SipServer.find(proxy_server_id)
    if server.config_port.nil?
      # TODO errormessage
      return false
    else
      SipproxyDbalias.set_resource( "http://#{server.name}:#{server.config_port}/" )
      sipproxy_dbalias = SipproxyDbalias.create(
        :username       =>  self.auth_name,
        :domain         =>  self.sip_server.name,
        :alias_username =>  self.phone_number,
        :alias_domain   =>  self.sip_server.name
      )
      if ! sipproxy_dbalias.valid?
        errors.add( :base, "Failed to create alias on SipProxy management server. (Reason:\n" +
        get_active_record_errors_from_remote( sipproxy_dbalias ).join(",\n") +
          ")" )
      end
    end
  end
  
  # Update alias on "SipProxy" proxy manager.
  #
  def update_alias_on_sipproxy( proxy_server_id, proxy_server_authname, proxy_server_alias )
    server = SipServer.find( proxy_server_id )
    if server.config_port.blank?
      # TODO errormessage
      return false  # return true?
    else
      SipproxyDbalias.set_resource( "http://#{server.name}:#{server.config_port}/" )
      update_dbalias = SipproxyDbalias.find( :first, :params => {'username'=> "#{proxy_server_authname}", 'alias_username' => "#{proxy_server_alias}"} )
      #FIXME - Catch exceptions by connection errors, see cantina_sip_account_update().
      case update_dbalias
        #when false
        #  errors.add( :base, "Failed to connect to SipProxy management server." )
        #  return false
        when nil
          # create instead
          return create_alias_on_sipproxy( proxy_server_id )
        else
          if ! update_dbalias.update_attributes({
            :username       =>  self.auth_name,
            :domain         =>  self.sip_server.name,
            :alias_username =>  self.phone_number,
            :alias_domain   =>  self.sip_server.name
          })
            log_active_record_errors_from_remote( update_dbalias )
            errors.add( :base, "Failed to update dbalias on SipProxy management server. (Reason:\n" +
            get_active_record_errors_from_remote( update_dbalias ).join(",\n") +
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
  def destroy_dbalias_on_sipproxy( proxy_server_id, proxy_server_authname, proxy_server_alias )
    begin
      server = SipServer.find(proxy_server_id)
      if server.config_port.nil?
        # TODO errormessage
        return false
      else
        SipproxyDbalias.set_resource( "http://#{server.name}:#{server.config_port}/" )
        destroy_dbalias = SipproxyDbalias.find( :first, :params => { 'username' => proxy_server_authname.to_s, 'alias_username' => proxy_server_alias.to_s })
        if ! destroy_dbalias.destroy
          errors.add( :base, "Failed to destroy dbalias on SipProxy management server. (Reason:\n" +
          get_active_record_errors_from_remote( sipproxy_dbalias ).join(",\n") +
            ")" )
        else
          return true
        end
      end
    rescue Errno::ECONNREFUSED => e
      logger.warn "Failed to connect to SipProxy management server. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to SipProxy management server." )
      return false
    rescue Errno::EADDRNOTAVAIL => e
      logger.warn "Failed to connect to SipProxy management server. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to SipProxy management server." )
      return false
    rescue Errno::EHOSTDOWN => e
      logger.warn "Failed to connect to SipProxy management server. (#{e.class}, #{e.message})"
      errors.add( :base, "Failed to connect to SipProxy management server." )
      return false
    end
  end
  
  # Log validation errors from the remote model.
  #
  def log_active_record_errors_from_remote( ar )
    if ar.respond_to?(:errors) && ar.errors.kind_of?(Hash)
      logger.info "----------------------------------------------------------"
      logger.info "Errors for #{ar.class} from Cantina:"
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
  
  # Get validation errors from the remote model.
  #
  def get_active_record_errors_from_remote( ar )
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
