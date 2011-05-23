class PhoneBookInternalUsersController < ApplicationController
  
  #OPTIMIZE Is this controller actually used for anything?
  #TODO Authentication and authorization.
  
  def index
    @sip_accounts = SipAccount.all
    respond_to { |format|
     format.xml
	}
  end
  
end
