class PersonalContactsController < ApplicationController
 
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
   
  # GET /personal_contacts
  # GET /personal_contacts.xml
  def index
    @personal_contacts = PersonalContact.accessible_by( current_ability, :index ).all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @personal_contacts }
    end
  end

  # GET /personal_contacts/1
  # GET /personal_contacts/1.xml
  def show
    @personal_contact = PersonalContact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @personal_contact }
    end
  end

  # GET /personal_contacts/new
  # GET /personal_contacts/new.xml
  def new
    @personal_contact = PersonalContact.new
    @user_role = current_user.role
    @users = User.all
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @personal_contact }
    end
  end

  # GET /personal_contacts/1/edit
  def edit
    @personal_contact = PersonalContact.find(params[:id])
  end

  # POST /personal_contacts
  # POST /personal_contacts.xml
  def create
    @personal_contact = PersonalContact.new(params[:personal_contact])

    respond_to do |format|
      if @personal_contact.save
        format.html { redirect_to(@personal_contact, :notice => 'Personal contact was successfully created.') }
        format.xml  { render :xml => @personal_contact, :status => :created, :location => @personal_contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @personal_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /personal_contacts/1
  # PUT /personal_contacts/1.xml
  def update
    @personal_contact = PersonalContact.find(params[:id])

    respond_to do |format|
      if @personal_contact.update_attributes(params[:personal_contact])
        format.html { redirect_to(@personal_contact, :notice => 'Personal contact was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @personal_contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /personal_contacts/1
  # DELETE /personal_contacts/1.xml
  def destroy
    @personal_contact = PersonalContact.find(params[:id])
    @personal_contact.destroy

    respond_to do |format|
      format.html { redirect_to(personal_contacts_url) }
      format.xml  { head :ok }
    end
  end
end
