class KamailioController < ApplicationController
  def index
    @sip_accounts = SipAccount.all

    respond_to do |format|
      format.txt      
    end
  end
end
