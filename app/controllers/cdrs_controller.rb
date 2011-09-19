class CdrsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  load_and_authorize_resource
  
  def index
    @cdrs = Cdr.accessible_by( current_ability, :index ).order(:start_stamp).page( params[:page] ).per(20)
  end
  
end

