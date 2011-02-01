class UserToPhonesController < ApplicationController
  # GET /user_to_phones
  # GET /user_to_phones.xml
  def index
    @user_to_phones = UserToPhone.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_to_phones }
    end
  end

  # GET /user_to_phones/1
  # GET /user_to_phones/1.xml
  def show
    @user_to_phone = UserToPhone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_to_phone }
    end
  end

  # GET /user_to_phones/new
  # GET /user_to_phones/new.xml
  def new
    @user_to_phone = UserToPhone.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_to_phone }
    end
  end

  # GET /user_to_phones/1/edit
  def edit
    @user_to_phone = UserToPhone.find(params[:id])
  end

  # POST /user_to_phones
  # POST /user_to_phones.xml
  def create
    @user_to_phone = UserToPhone.new(params[:user_to_phone])

    respond_to do |format|
      if @user_to_phone.save
        format.html { redirect_to(@user_to_phone, :notice => 'User to phone was successfully created.') }
        format.xml  { render :xml => @user_to_phone, :status => :created, :location => @user_to_phone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_to_phone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_to_phones/1
  # PUT /user_to_phones/1.xml
  def update
    @user_to_phone = UserToPhone.find(params[:id])

    respond_to do |format|
      if @user_to_phone.update_attributes(params[:user_to_phone])
        format.html { redirect_to(@user_to_phone, :notice => 'User to phone was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_to_phone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_to_phones/1
  # DELETE /user_to_phones/1.xml
  def destroy
    @user_to_phone = UserToPhone.find(params[:id])
    @user_to_phone.destroy

    respond_to do |format|
      format.html { redirect_to(user_to_phones_url) }
      format.xml  { head :ok }
    end
  end
end
