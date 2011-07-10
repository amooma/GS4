class GlobalContactsController < ApplicationController

  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource

  # GET /global_contacts
  # GET /global_contacts.xml
  def index
    @global_contacts = GlobalContact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @global_contacts }
    end
  end

  # GET /global_contacts/1
  # GET /global_contacts/1.xml
  def show
    @global_contact = GlobalContact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @global_contact }
    end
  end

  # GET /global_contacts/new
  # GET /global_contacts/new.xml
  def new
    @global_contact = GlobalContact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @global_contact }
    end
  end

  # GET /global_contacts/1/edit
  def edit
    @global_contact = GlobalContact.find(params[:id])
  end

  # POST /global_contacts
  # POST /global_contacts.xml
  def create
    @global_contact = GlobalContact.new(params[:global_contact])

    respond_to do |format|
      if @global_contact.save
        format.html { redirect_to(@global_contact, :notice => t(:global_contact_updated)) }
        format.xml  { render :xml => @global_contact, :status => :created, :location => @global_contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @global_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /global_contacts/1
  # PUT /global_contacts/1.xml
  def update
    @global_contact = GlobalContact.find(params[:id])

    respond_to do |format|
      if @global_contact.update_attributes(params[:global_contact])
        format.html { redirect_to(@global_contact, :notice => t(:global_contact_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @global_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /global_contacts/1
  # DELETE /global_contacts/1.xml
  def destroy
    @global_contact = GlobalContact.find(params[:id])
    @global_contact.destroy

    respond_to do |format|
      format.html { redirect_to(global_contacts_url) }
      format.xml  { head :ok }
    end
  end
end
