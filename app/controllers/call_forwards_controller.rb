class CallForwardsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  before_filter { |controller|
    @sip_accounts = SipAccount.accessible_by( current_ability, :read_title ).all
  }
  
  
  # GET /call_forwards
  # GET /call_forwards.xml
  def index
    @call_forwards = CallForward.accessible_by( current_ability, :index ).all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @call_forwards }
    end
  end

  # GET /call_forwards/1
  # GET /call_forwards/1.xml
  def show
    @call_forward = CallForward.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @call_forward }
    end
  end

  # GET /call_forwards/new
  # GET /call_forwards/new.xml
  def new
    @call_forward = CallForward.new
    @call_forward.active = true

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @call_forward }
    end
  end

  # GET /call_forwards/1/edit
  def edit
    @call_forward = CallForward.find(params[:id])
  end

  # POST /call_forwards
  # POST /call_forwards.xml
  def create
    @call_forward = CallForward.new(params[:call_forward])

    respond_to do |format|
      if @call_forward.save
        format.html { redirect_to(@call_forward, :notice => t(:call_forward_created)) }
        format.xml  { render :xml => @call_forward, :status => :created, :location => @call_forward }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @call_forward.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /call_forwards/1
  # PUT /call_forwards/1.xml
  def update
    @call_forward = CallForward.find(params[:id])

    respond_to do |format|
      if @call_forward.update_attributes(params[:call_forward])
        format.html { redirect_to(@call_forward, :notice => t(:call_forward_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @call_forward.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /call_forwards/1
  # DELETE /call_forwards/1.xml
  def destroy
    @call_forward = CallForward.find(params[:id])
    @call_forward.destroy

    respond_to do |format|
      format.html { redirect_to(call_forwards_url) }
      format.xml  { head :ok }
    end
  end
  
end
