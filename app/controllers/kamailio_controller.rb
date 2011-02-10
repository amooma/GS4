class KamailioController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /kamailio
  # GET /kamailio.txt
  def index
    @sip_users = SipUser.all
    @sip_users.delete_if{|sip_user| sip_user.sip_server == nil}
    
    respond_to do |format|
      format.txt      
    end
  end
  
end
