class SubscribersController < ApplicationController
  
  before_filter :authenticate_user!

  # GET /subscribers
  # GET /subscribers.xml
  def index
    if params[:username]
      @subscribers = Subscriber.find :all, :conditions => ['username = ?', params[:username]] 
    else
      @subscribers = Subscriber.find(:all)
    end


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subscribers }
    end
  end

  # GET /subscribers/1
  # GET /subscribers/1.xml
  def show
    @subscriber = Subscriber.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subscriber }
    end
  end

  # GET /subscribers/new
  # GET /subscribers/new.xml
  def new
    @subscriber = Subscriber.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subscriber }
    end
  end
  
end
