class DialplanPatternsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  
  # GET /dialplan_patterns
  # GET /dialplan_patterns.xml
  def index
    @dialplan_patterns = DialplanPattern.order(:pattern).all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dialplan_patterns }
    end
  end
  
  # GET /dialplan_patterns/1
  # GET /dialplan_patterns/1.xml
  def show
    @dialplan_pattern = DialplanPattern.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dialplan_pattern }
    end
  end
  
  # GET /dialplan_patterns/new
  # GET /dialplan_patterns/new.xml
  def new
    @dialplan_pattern = DialplanPattern.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dialplan_pattern }
    end
  end
  
  # GET /dialplan_patterns/1/edit
  def edit
    @dialplan_pattern = DialplanPattern.find(params[:id])
  end
  
  # POST /dialplan_patterns
  # POST /dialplan_patterns.xml
  def create
    @dialplan_pattern = DialplanPattern.new(params[:dialplan_pattern])
    
    respond_to do |format|
      if @dialplan_pattern.save
        #format.html { redirect_to( @dialplan_pattern, :notice => t('dp_pattern.was_created') )}
        format.html { redirect_to( dialplan_patterns_url, :notice => t('dp_pattern.was_created') ) }
        format.xml  { render :xml => @dialplan_pattern, :status => :created, :location => @dialplan_pattern }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dialplan_pattern.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /dialplan_patterns/1
  # PUT /dialplan_patterns/1.xml
  def update
    @dialplan_pattern = DialplanPattern.find(params[:id])
    
    respond_to do |format|
      if @dialplan_pattern.update_attributes(params[:dialplan_pattern])
        #format.html { redirect_to( @dialplan_pattern, :notice => t('dp_pattern.was_updated') )}
        format.html { redirect_to( dialplan_patterns_url, :notice => t('dp_pattern.was_updated') ) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dialplan_pattern.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /dialplan_patterns/1
  # DELETE /dialplan_patterns/1.xml
  def destroy
    @dialplan_pattern = DialplanPattern.find(params[:id])
    
    begin
      @dialplan_pattern.destroy
      
      respond_to do |format|
        format.html { redirect_to( dialplan_patterns_url ) }
        format.xml  { head :ok }
      end
    
    rescue ::ActiveRecord::DeleteRestrictionError => e
      @dialplan_pattern.errors.add( :base, "#{t(:dependent_restricted)} (#{e.message})" )
      
      respond_to do |format|
        format.html { redirect_to( dialplan_patterns_url, :alert => "#{t(:dependent_restricted)} (#{e.message})" ) }
        format.xml  { render :xml => @dialplan_pattern.errors, :status => :failed_dependency }
      end
    end
  end
  
end
