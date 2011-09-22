class DialplanRoutesController < ApplicationController
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  before_filter { |controller|
    @dp_patterns_by_pattern   = DialplanPattern .accessible_by( current_ability, :index ).order([ :pattern ])
    @dp_patterns_by_name      = DialplanPattern .accessible_by( current_ability, :index ).order([ :name ])
    @dp_patterns              = @dp_patterns_by_pattern
    @users         = User            .accessible_by( current_ability, :index ).order([ :sn, :gn, :username ]).keep_if{ |u| Ability.new(u).can?(:have, SipAccount) }
    @sip_gws       = SipGateway      .accessible_by( current_ability, :index ).order([ :host, :port ])
  }
  
  
  # GET /dialplan_routes
  # GET /dialplan_routes.xml
  def index
    @dialplan_routes = DialplanRoute.order(:position).all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dialplan_routes }
    end
  end
  
  # GET  /dialplan_routes/test
  # POST /dialplan_routes/test
  def test
    @dialplan_routes = DialplanRoute.order(:position).all
    @sip_accounts = SipAccount.accessible_by( current_ability, :index ).all
    @test_view = true
    
    @test_call_dest = (params[:test_call] || {})[:dest]
    @test_call_dest = nil if @test_call_dest.blank?
    if @test_call_dest
      @is_test_call = true
      @test_call_sip_acct_id = (params[:test_call] || {})[:sip_acct_id].to_i
      @test_call_sip_acct = SipAccount.where(:id => @test_call_sip_acct_id).first
      @is_extension = Extension.where(:active => true, :extension => @test_call_dest).count > 0
    else
      @is_test_call = false
      @test_call_sip_acct_id = nil
      @test_call_sip_acct = nil
      @is_extension = false
    end
    
    respond_to do |format|
      format.html # test.html.erb
    end
  end
  
  # GET /dialplan_routes/1
  # GET /dialplan_routes/1.xml
  def show
    @dialplan_route = DialplanRoute.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dialplan_route }
    end
  end
  
  # GET /dialplan_routes/new
  # GET /dialplan_routes/new.xml
  def new
    @dialplan_route = DialplanRoute.new
    @dialplan_route.eac = '0'  # most common external access code (EAC)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dialplan_route }
    end
  end
  
  # GET /dialplan_routes/1/edit
  def edit
    @dialplan_route = DialplanRoute.find(params[:id])
  end
  
  # POST /dialplan_routes
  # POST /dialplan_routes.xml
  def create
    @dialplan_route = DialplanRoute.new(params[:dialplan_route])
    
    respond_to do |format|
      if @dialplan_route.save
        #format.html { redirect_to( @dialplan_route, :notice => t('dp_route.was_created') )}
        format.html { redirect_to( dialplan_routes_url, :notice => t('dp_route.was_created') ) }
        format.xml  { render :xml => @dialplan_route, :status => :created, :location => @dialplan_route }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dialplan_route.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /dialplan_routes/1
  # PUT /dialplan_routes/1.xml
  def update
    @dialplan_route = DialplanRoute.find(params[:id])
    
    respond_to do |format|
      if @dialplan_route.update_attributes(params[:dialplan_route])
        #format.html { redirect_to( @dialplan_route, :notice => t('dp_route.was_updated') )}
        format.html { redirect_to( dialplan_routes_url, :notice => t('dp_route.was_updated') ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dialplan_route.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /dialplan_routes/1
  # DELETE /dialplan_routes/1.xml
  def destroy
    @dialplan_route = DialplanRoute.find(params[:id])
    @dialplan_route.destroy
    
    respond_to do |format|
      format.html { redirect_to( dialplan_routes_url ) }
      format.xml  { head :ok }
    end
  end
  
  
  def confirm_destroy
    @dialplan_route = DialplanRoute.find(params[:id])
  end
  
  
  # POST dialplan_routes/1/move_up
  def move_up
    @dialplan_route = DialplanRoute.find(params[:id])
    @dialplan_route.move_higher if @dialplan_route
    respond_to do |format|
      format.html { redirect_to( :action => :index, :moved_id => @dialplan_route.try(:id) )}
      format.xml  { head :ok }
    end
  end
  
  # POST dialplan_routes/1/move_down
  def move_down
    @dialplan_route = DialplanRoute.find(params[:id])
    @dialplan_route.move_lower if @dialplan_route
    respond_to do |format|
      format.html { redirect_to( :action => :index, :moved_id => @dialplan_route.try(:id) )}
      format.xml  { head :ok }
    end
  end
  
  # POST dialplan_routes/1/move_to_top
  def move_to_top
    @dialplan_route = DialplanRoute.find(params[:id])
    @dialplan_route.move_to_top if @dialplan_route
    respond_to do |format|
      format.html { redirect_to( :action => :index, :moved_id => @dialplan_route.try(:id) )}
      format.xml  { head :ok }
    end
  end
  
  # POST dialplan_routes/1/move_to_bottom
  def move_to_bottom
    @dialplan_route = DialplanRoute.find(params[:id])
    @dialplan_route.move_to_bottom if @dialplan_route
    respond_to do |format|
      format.html { redirect_to( :action => :index, :moved_id => @dialplan_route.try(:id) )}
      format.xml  { head :ok }
    end
  end
  
  
end
