class SipUsersController < ApplicationController
  # GET /sip_users
  # GET /sip_users.xml
  def index
    @sip_users = SipUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sip_users }
    end
  end

  # GET /sip_users/1
  # GET /sip_users/1.xml
  def show
    @sip_user = SipUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sip_user }
    end
  end

  # GET /sip_users/new
  # GET /sip_users/new.xml
  def new
    @sip_user = SipUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sip_user }
    end
  end

  # GET /sip_users/1/edit
  def edit
    @sip_user = SipUser.find(params[:id])
  end

  # POST /sip_users
  # POST /sip_users.xml
  def create
    @sip_user = SipUser.new(params[:sip_user])

    respond_to do |format|
      if @sip_user.save
        format.html { redirect_to(@sip_user, :notice => 'Sip user was successfully created.') }
        format.xml  { render :xml => @sip_user, :status => :created, :location => @sip_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sip_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sip_users/1
  # PUT /sip_users/1.xml
  def update
    @sip_user = SipUser.find(params[:id])

    respond_to do |format|
      if @sip_user.update_attributes(params[:sip_user])
        format.html { redirect_to(@sip_user, :notice => 'Sip user was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sip_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sip_users/1
  # DELETE /sip_users/1.xml
  def destroy
    @sip_user = SipUser.find(params[:id])
    @sip_user.destroy

    respond_to do |format|
      format.html { redirect_to(sip_users_url) }
      format.xml  { head :ok }
    end
  end
end
