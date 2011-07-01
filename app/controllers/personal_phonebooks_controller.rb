class PersonalPhonebooksController < ApplicationController
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource

  # GET /personal_phonebooks
  # GET /personal_phonebooks.xml
  def index
    @personal_phonebooks = PersonalPhonebook.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @personal_phonebooks }
    end
  end

  # GET /personal_phonebooks/1
  # GET /personal_phonebooks/1.xml
  def show
    @personal_phonebook = PersonalPhonebook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @personal_phonebook }
    end
  end

  # GET /personal_phonebooks/new
  # GET /personal_phonebooks/new.xml
  def new
    @personal_phonebook = PersonalPhonebook.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @personal_phonebook }
    end
  end

  # GET /personal_phonebooks/1/edit
  def edit
    @personal_phonebook = PersonalPhonebook.find(params[:id])
  end

  # POST /personal_phonebooks
  # POST /personal_phonebooks.xml
  def create
    @personal_phonebook = PersonalPhonebook.new(params[:personal_phonebook])

    respond_to do |format|
      if @personal_phonebook.save
        format.html { redirect_to(@personal_phonebook, :notice => 'Personal phonebook was successfully created.') }
        format.xml  { render :xml => @personal_phonebook, :status => :created, :location => @personal_phonebook }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @personal_phonebook.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /personal_phonebooks/1
  # PUT /personal_phonebooks/1.xml
  def update
    @personal_phonebook = PersonalPhonebook.find(params[:id])

    respond_to do |format|
      if @personal_phonebook.update_attributes(params[:personal_phonebook])
        format.html { redirect_to(@personal_phonebook, :notice => 'Personal phonebook was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @personal_phonebook.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /personal_phonebooks/1
  # DELETE /personal_phonebooks/1.xml
  def destroy
    @personal_phonebook = PersonalPhonebook.find(params[:id])
    @personal_phonebook.destroy

    respond_to do |format|
      format.html { redirect_to(personal_phonebooks_url) }
      format.xml  { head :ok }
    end
  end
end
