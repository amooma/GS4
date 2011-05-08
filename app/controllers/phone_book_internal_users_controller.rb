class PhoneBookInternalUsersController < ApplicationController
  def index
    @sip_accounts = SipAccount.all
    respond_to { |format|
     format.xml
	}
  end
end
