class CdrsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  def index
    @cdrs = Cdr.order(:start_stamp).page(params[:page]).per(2)
    #FIXME .per(2) only for Testing
  end
  
end

