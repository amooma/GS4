class LdapImportSessionsController < ApplicationController
  skip_authorization_check
  
  # GET /ldap_import_sessions/new
  # GET /ldap_import_sessions/new.xml
  def new
    @ldap_import_session = LdapImportSession.new
    @ldap_import_session.version = 3
    @ldap_import_session.ssl = false
    @ldap_import_session.port = 389

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ldap_import_session }
    end
  end

  # POST /ldap_import_sessions
  # POST /ldap_import_sessions.xml
  def create
    @ldap_import_session = LdapImportSession.new(params[:ldap_import_session])

    respond_to do |format|
      if @ldap_import_session.valid?
        format.html { redirect_to(@ldap_import_session, :notice => 'Ldap import session was successfully created.') }
        format.xml  { render :xml => @ldap_import_session, :status => :created, :location => @ldap_import_session }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ldap_import_session.errors, :status => :unprocessable_entity }
      end
    end
  end
end
