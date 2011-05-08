class PhoneBookInternalUsersController < ApplicationController
  def index
    @sip_accounts = SipAccount.all
    respond_to { |format|
     ormat.xml  { render :xml => @sip_accounts }
	} 
  end
end
