module PhoneAuth
  def phone_is_registered(ip)
    @registered_location = Location.find(:first, :conditions => ['socket LIKE ?', "%#{ip}%"])
    if @registered_location
      true
    else
      false
    end
  end
  def user_on_phone(ip)
    if phone_is_registered(ip)
      SipAccount.where(:auth_name => @registered_location.username).first.try(:user)
    else
      nil
    end
  end
end
