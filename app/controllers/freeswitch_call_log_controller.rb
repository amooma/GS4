class FreeswitchCallLogController < ApplicationController
  skip_authorization_check
  # Allow access from 127.0.0.1 and [::1] only:
  prepend_before_filter { |controller|
    if ! request.local?
      if user_signed_in? && current_user.role == "admin"
        # For debugging purposes.
        logger.info(_bold( "#{logpfx} Request from #{request.remote_addr.inspect} is not local but the user is an admin ..." ))
      else
        logger.info(_bold( "#{logpfx} Denying non-local request from #{request.remote_addr.inspect} ..." ))
        render :status => '403 None of your business',
          :layout => false, :content_type => 'text/plain',
          :text => "<!-- This is none of your business. -->"
        # Maybe allow access in "development" mode?
      end
    end
  }
  
  def set_missed_call
    disposition = Cdr.where(:uuid => params[:uuid]).first.try(:hangup_cause)
    call_log = CallLog.where(:uuid => params[:uuid], :call_type => "in")

    if ! call_log.nil? && disposition != "NORMAL_CLEARING"
      call_log.each do |c|
        c.update_attributes(:disposition => "noanswer")
      end
    end
    respond_to do |format|
      format.html 
    end
  end
end