class SipGateway < ActiveRecord::Base
	
	before_validation {
		self.port           = nil if self.port           .blank?
		self.realm          = nil if self.realm          .blank?
		self.username       = nil if self.username       .blank?
		self.from_user      = nil if self.from_user      .blank?
		self.from_domain    = nil if self.from_domain    .blank?
		self.reg_transport  = nil if self.reg_transport  .blank?
		self.expire         = nil if self.expire         .blank?
	}
	
	validates_presence_of     :host
	validate_hostname_or_ip   :host, :allow_nil => false, :allow_blank => false
	validates_uniqueness_of   :host, :case_sensitive => false, :scope => :port
	
	validate_ip_port          :port, :allow_nil => true, :allow_blank => false  # empty SIP port means default SIP port (SRV lookups)
	validates_uniqueness_of   :port, :scope => :host
	
	validates_format_of       :realm,
		:with => /^[a-zA-Z0-9\-.]+$/,
		:allow_nil => true,
		:allow_blank => false
	
	validates_presence_of     :username
	validate_username         :username, :allow_nil => false, :allow_blank => false
	
	validates_presence_of     :password
	validate_password         :password, :allow_nil => false, :allow_blank => false
	
	validate_username         :from_user, :allow_nil => true, :allow_blank => false
	
	validate_hostname_or_ip   :from_domain, :allow_nil => true, :allow_blank => false
	
	validates_inclusion_of    :register, :in => [ true, false ], :allow_nil => false
	
	validates_inclusion_of    :reg_transport, :in => [ 'udp', 'tcp' ], :allow_nil => false
	
	validates_presence_of     :expire
	validates_numericality_of :expire, :only_integer => true,
		:greater_than_or_equal_to  =>   120,
		:less_than_or_equal_to     =>  3600,
		:allow_nil => false, :allow_blank => false
	
	after_save {
		#Rails.logger.info( "------- after_save" )
		self.sofia_profile_reload_and_restart()
	}
	after_destroy {
		#Rails.logger.info( "------- after_destroy" )
		self.sofia_profile_reload_and_restart()
	}
	
	def hostport
		return \
			(! self.host.to_s.match(/[:]/) ? self.host.to_s : ('[' + self.host.to_s + ']')) + \
			(self.port.blank? ? '' : (':' + self.port.to_s))
	end
	
	FREESWITCH_GATEWAYS_PROFILE = 'internal'  # do not change
	
	protected
	
	def sofia_profile_reload_and_restart
		#if ::Rails.env.to_s != 'test'
			require 'xml_rpc'
			job_uuid = ::XmlRpc::sofia_profile_reload_and_restart( ::SipGateway::FREESWITCH_GATEWAYS_PROFILE )
			#Rails.logger.info "-------------- #{result.inspect}"
		#end
	end
	
end
