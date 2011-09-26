class ConferencesController < ApplicationController
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  before_filter { |controller|
    @users = User.accessible_by( current_ability, :index ).all
  }

  # GET /conferences
  # GET /conferences.xml
  def index
    @conferences = Conference.includes(:extensions).order('extensions.extension ASC').accessible_by( current_ability, :index ).all

    respond_to do |format|
      if Conference.all.blank? && can?( :new, Conference )
        format.html { redirect_to(new_conference_path, :notice => t(:no_call_queue_in_db_so_redirect_to_new)) }
      else
        format.html # index.html.erb
      end
      format.xml  { render :xml => @conferences }
    end
  end

  # GET /conferences/1
  # GET /conferences/1.xml
  def show
    @conference = Conference.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @conference }
    end
  end

  # GET /conferences/new
  # GET /conferences/new.xml
  def new
    @conference = Conference.new
    @conference.uuid = "-conference-#{SecureRandom.hex(10)}"
    @conference.name = "#{t(:conference)}-#{Conference.count + 1}"
    @conference.pin = 100000 + SecureRandom.random_number( 899999 )
    
    extension = @conference.extensions.build(
      :extension => Extension.next_unused_extension,
      :destination => @conference.uuid,
      :active => true,
    )

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @conference }
    end
  end

  # GET /conferences/1/edit
  def edit
    @conference = Conference.find(params[:id])
  end

  # POST /conferences
  # POST /conferences.xml
  def create
    @conference = Conference.new(params[:conference])

    respond_to do |format|
      if @conference.save
        format.html { redirect_to(@conference, :notice => t(:conference_created)) }
        format.xml  { render :xml => @conference, :status => :created, :location => @conference }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @conference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /conferences/1
  # PUT /conferences/1.xml
  def update
    @conference = Conference.find(params[:id])

    respond_to do |format|
      if @conference.update_attributes(params[:conference])
        format.html { redirect_to(@conference, :notice => t(:conference_updated)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @conference.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /conferences/1
  # DELETE /conferences/1.xml
  def destroy
    @conference = Conference.find(params[:id])
    @conference.destroy

    respond_to do |format|
      format.html { redirect_to(conferences_url) }
      format.xml  { head :ok }
    end
  end
  
end
