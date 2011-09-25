class LdapImportSessionsController < ApplicationController
  # GET /ldap_import_sessions
  # GET /ldap_import_sessions.xml
  def index
    @ldap_import_sessions = LdapImportSession.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ldap_import_sessions }
    end
  end

  # GET /ldap_import_sessions/1
  # GET /ldap_import_sessions/1.xml
  def show
    @ldap_import_session = LdapImportSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ldap_import_session }
    end
  end

  # GET /ldap_import_sessions/new
  # GET /ldap_import_sessions/new.xml
  def new
    @ldap_import_session = LdapImportSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ldap_import_session }
    end
  end

  # GET /ldap_import_sessions/1/edit
  def edit
    @ldap_import_session = LdapImportSession.find(params[:id])
  end

  # POST /ldap_import_sessions
  # POST /ldap_import_sessions.xml
  def create
    @ldap_import_session = LdapImportSession.new(params[:ldap_import_session])

    respond_to do |format|
      if @ldap_import_session.save
        format.html { redirect_to(@ldap_import_session, :notice => 'Ldap import session was successfully created.') }
        format.xml  { render :xml => @ldap_import_session, :status => :created, :location => @ldap_import_session }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ldap_import_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ldap_import_sessions/1
  # PUT /ldap_import_sessions/1.xml
  def update
    @ldap_import_session = LdapImportSession.find(params[:id])

    respond_to do |format|
      if @ldap_import_session.update_attributes(params[:ldap_import_session])
        format.html { redirect_to(@ldap_import_session, :notice => 'Ldap import session was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ldap_import_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ldap_import_sessions/1
  # DELETE /ldap_import_sessions/1.xml
  def destroy
    @ldap_import_session = LdapImportSession.find(params[:id])
    @ldap_import_session.destroy

    respond_to do |format|
      format.html { redirect_to(ldap_import_sessions_url) }
      format.xml  { head :ok }
    end
  end
end
