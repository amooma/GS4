class KamailioController < ApplicationController
  def index
    @sip_users = SipUser.all

    respond_to do |format|
      format.txt      
    end
  end
end
