class PhoneBookInternalUsersController < ApplicationController
  
  #OPTIMIZE Is this controller actually used for anything? It doesn't even have any views.
  #TODO Authentication and authorization. (=> pko)
  
  # https://github.com/ryanb/cancan/wiki/authorizing-controller-actions
  #load_and_authorize_resource
  # PhoneBookInternalUsers isn't a resource.
  skip_authorization_check
  
  
  def index
    @sip_accounts = SipAccount.accessible_by( current_ability, :index ).all
    
    respond_to { |format|
      format.xml
	}
  end
  
end
