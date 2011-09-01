class SipGatewaysController < ApplicationController
	
	before_filter :authenticate_user!
	
	# https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
	load_and_authorize_resource
	
	
	before_filter { |controller|
		require 'xml_rpc'
		
		
		@reg_states = {}
		[
			'TRYING',
			'REGISTER',
			'REGED',
			'UNREGED',
			'UNREGISTER',
			'FAILED',
			'FAIL_WAIT',
			'EXPIRED',
			'NOREG',
			'NOAVAIL',
		].each { |k|
			@reg_states[k] = I18n.t( 'freeswitch_api.reg_states.' + k ).to_s
		}
		
		@gw_statuses = {}
		[
			'DOWN',
			'UP',
		].each { |k|
			@gw_statuses[k] = I18n.t( 'freeswitch_api.gw_statuses.' + k ).to_s
		}
	}
	
	# GET /sip_gateways
	# GET /sip_gateways.xml
	def index
		@sip_gateways = SipGateway.accessible_by( current_ability, :index ).all
		
		@freeswitch_gateways = ::XmlRpc::sofia_gateway_states( ::SipGateway::FREESWITCH_GATEWAYS_PROFILE )
		#Rails.logger.info "-------------- #{@freeswitch_gateways.inspect}"
		
		respond_to do |format|
			format.html # index.html.erb
			format.xml  { render :xml => @sip_gateways }
		end
	end
	
	# GET /sip_gateways/1
	# GET /sip_gateways/1.xml
	def show
		@sip_gateway = SipGateway.find( params[:id] )
		
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @sip_gateway }
		end
	end
	
	# GET /sip_gateways/new
	# GET /sip_gateways/new.xml
	def new
		@sip_gateway = SipGateway.new
		@sip_gateway.register       = true
		@sip_gateway.reg_transport  = 'udp'
		@sip_gateway.expire         = '1800'
		
		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @sip_gateway }
		end
	end
	
	# GET /sip_gateways/1/edit
	def edit
		@sip_gateway = SipGateway.find( params[:id] )
	end
	
	# POST /sip_gateways
	# POST /sip_gateways.xml
	def create
		@sip_gateway = SipGateway.new(params[:sip_gateway])
		
		respond_to do |format|
			if @sip_gateway.save
				format.html { redirect_to( @sip_gateway, :notice => t(:sip_gateway_was_created) ) }
				format.xml  { render :xml => @sip_gateway, :status => :created, :location => @sip_gateway }
			else
				format.html { render :action => "new" }
				format.xml  { render :xml => @sip_gateway.errors, :status => :unprocessable_entity }
			end
		end
	end
	
	# PUT /sip_gateways/1
	# PUT /sip_gateways/1.xml
	def update
		@sip_gateway = SipGateway.find( params[:id] )
		
		respond_to do |format|
			if @sip_gateway.update_attributes(params[:sip_gateway])
				format.html { redirect_to( @sip_gateway, :notice => t(:sip_gateway_was_updated) ) }
				format.xml  { head :ok }
			else
				format.html { render :action => "edit" }
				format.xml  { render :xml => @sip_gateway.errors, :status => :unprocessable_entity }
			end
		end
	end
	
	# DELETE /sip_gateways/1
	# DELETE /sip_gateways/1.xml
	def destroy
		@sip_gateway = SipGateway.find( params[:id] )
		@sip_gateway.destroy
		
		respond_to do |format|
			format.html { redirect_to( sip_gateways_url ) }
			format.xml  { head :ok }
		end
	end
	
end
