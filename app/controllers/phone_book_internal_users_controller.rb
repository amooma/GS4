class PhoneBookInternalUsersController < ApplicationController
  
  #TODO Authentication and authorization.
  
  def index
    @sip_accounts = SipAccount.all
    respond_to { |format|
     format.xml
	}
  end
end
