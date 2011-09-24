class EmailConfiguration
	extend ActiveModel::Naming
	include ActiveModel::Validations
	include ActiveModel::Conversion
	include ActiveModel::Translation
	#include ActiveSupport::Callbacks
	
	attr_reader   :errors
	
	attr_accessor(
		:smarthost_hostname,
		:smarthost_port,
		:smarthost_domain,
		:smarthost_username,
		:smarthost_password,
		:smarthost_from_address,
		:smarthost_authentication,
		:smarthost_enable_starttls_auto,
		
		:mailserver_hostname,
		:mailserver_port,
		:mailserver_username,
		:mailserver_password,
		
		:fax_send_mail,
		:fax_pop3,
	)
	
	def initialize( attrs = nil )
		
		@attributes = {
			:smarthost_hostname              => Cfg.str(  :smarthost_hostname, '127.0.0.1' ),
			:smarthost_port                  => Cfg.int(  :smarthost_port, 25 ),
			:smarthost_domain                => Cfg.str(  :smarthost_domain, 'gemeinschaft.local' ),
			:smarthost_username              => Cfg.str(  :smarthost_username, '' ),
			:smarthost_password              => Cfg.str(  :smarthost_password, '' ),
			:smarthost_from_address          => Cfg.str(  :smarthost_from_address, '' ),
			:smarthost_authentication        => Cfg.str(  :smarthost_authentication, 'plain' ),
			:smarthost_enable_starttls_auto  => Cfg.bool( :smarthost_enable_starttls_auto, true ),
			
			:mailserver_hostname  => Cfg.str(  :mailserver_hostname ),
			:mailserver_port      => Cfg.int(  :mailserver_port, 110 ),
			:mailserver_username  => Cfg.str(  :mailserver_username ),
			:mailserver_password  => Cfg.str(  :mailserver_password ),
			
			:fax_send_mail  => Cfg.bool( :fax_send_mail, true ),
			:fax_pop3       => Cfg.bool( :fax_pop3, false ),
		}
		
		if attrs
			attrs2 = {}
			attrs.each { |k,v|
				attrs2[ k.to_sym ] = v
			}
			attrs = attrs2
			
			@attributes.merge!( attrs )
		end
		@attributes.each_pair { |attr, val|
			self.send( "#{attr}=", val )
		}
		
		@errors = ActiveModel::Errors.new(self)
	end
	
	def persisted?
		false
	end
	
	validate_hostname_or_ip   :smarthost_hostname  , :allow_nil => true, :allow_blank => true
	validate_ip_port          :smarthost_port      , :allow_nil => true, :allow_blank => true
	validate_hostname_or_ip   :smarthost_domain    , :allow_nil => true, :allow_blank => true
	validate_username         :smarthost_username  , :allow_nil => true, :allow_blank => true
	validate_password         :smarthost_password  , :allow_nil => true, :allow_blank => true
	#OPTIMIZE Validate :smarthost_from_address.
	validates_inclusion_of    :smarthost_authentication, :in => [ 'plain' ]
	validates_inclusion_of    :smarthost_enable_starttls_auto, :in => [ false, true, '1', '0', 'on' ]
	
	validate_hostname_or_ip   :mailserver_hostname  , :allow_nil => true, :allow_blank => true
	validate_ip_port          :mailserver_port      , :allow_nil => true, :allow_blank => true
	validate_username         :mailserver_username  , :allow_nil => true, :allow_blank => true
	validate_password         :mailserver_password  , :allow_nil => true, :allow_blank => true
	
	validates_inclusion_of    :fax_send_mail, :in => [ false, true, '1', '0', 'on' ]
	validates_inclusion_of    :fax_pop3, :in => [ false, true, '1', '0', 'on' ]
	
	
	def save
		#run_callbacks :validate
		run_validations!
		@errors.each_key { |attr|
			@errors[attr].uniq!
		}
		valid = @errors.empty?
		
		if valid
			@attributes.each_pair { |attr, val|
				if [
					:fax_send_mail,
					:fax_pop3,
					:smarthost_enable_starttls_auto,
				].include?( attr.to_sym )
					val = [ true, 'true', '1', 'on' ].include?( val )
				end
				Cfg.store( attr, val )
			}
		end
		
		return valid
	end
	
	def read_attribute_for_validation( attr )
		send( attr )
	end
	
	#def i18n_scope
	#	:activemodel
	#end

	#def self.human_attribute_name( attr, options = {} )
	#	attr
	#end
	
	#def self.lookup_ancestors
	#	[self]
	#end
end
