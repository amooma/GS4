class SipAccountToSipUsersController < ApplicationController
  # GET /sip_account_to_sip_users
  # GET /sip_account_to_sip_users.xml
  def index
    @sip_account_to_sip_users = SipAccountToSipUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sip_account_to_sip_users }
    end
  end

  # GET /sip_account_to_sip_users/1
  # GET /sip_account_to_sip_users/1.xml
  def show
    @sip_account_to_sip_user = SipAccountToSipUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sip_account_to_sip_user }
    end
  end

  # GET /sip_account_to_sip_users/new
  # GET /sip_account_to_sip_users/new.xml
  def new
    @sip_account_to_sip_user = SipAccountToSipUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sip_account_to_sip_user }
    end
  end

  # GET /sip_account_to_sip_users/1/edit
  def edit
    @sip_account_to_sip_user = SipAccountToSipUser.find(params[:id])
  end

  # POST /sip_account_to_sip_users
  # POST /sip_account_to_sip_users.xml
  def create
    @sip_account_to_sip_user = SipAccountToSipUser.new(params[:sip_account_to_sip_user])

    respond_to do |format|
      if @sip_account_to_sip_user.save
        format.html { redirect_to(@sip_account_to_sip_user, :notice => 'Sip account to sip user was successfully created.') }
        format.xml  { render :xml => @sip_account_to_sip_user, :status => :created, :location => @sip_account_to_sip_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sip_account_to_sip_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sip_account_to_sip_users/1
  # PUT /sip_account_to_sip_users/1.xml
  def update
    @sip_account_to_sip_user = SipAccountToSipUser.find(params[:id])

    respond_to do |format|
      if @sip_account_to_sip_user.update_attributes(params[:sip_account_to_sip_user])
        format.html { redirect_to(@sip_account_to_sip_user, :notice => 'Sip account to sip user was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sip_account_to_sip_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sip_account_to_sip_users/1
  # DELETE /sip_account_to_sip_users/1.xml
  def destroy
    @sip_account_to_sip_user = SipAccountToSipUser.find(params[:id])
    @sip_account_to_sip_user.destroy

    respond_to do |format|
      format.html { redirect_to(sip_account_to_sip_users_url) }
      format.xml  { head :ok }
    end
  end
end
