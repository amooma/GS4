module ApplicationHelper
  # Define the top navigation menu_items content
  #
  def top_menu_items_array
    if user_signed_in?
      menu_items = [
        { :text => "Admin"         , :url => url_for( :controller => '/admin' ) },
        { :text => "Users"         , :url => url_for( :controller => '/admin/user' ) },
        { :text => "Phones"        , :url => sip_phones_path },
        { :text => "SIP Accounts"  , :url => sip_accounts_path },
        { :text => "Extensions"    , :url => extensions_path },
        { :text => "Servers"       , :sub => [
          { :text => "Provisioning Servers" , :url => provisioning_servers_path },
          { :text => "SIP Servers"          , :url => sip_servers_path },
          { :text => "SIP Proxies"          , :url => sip_proxies_path }
          ]}
        ]
    else
        menu_items = [
          { :text => "Sign in"       , :url => new_user_session_path }
        ]
    end
    return menu_items
  end
  
end

#menu_items = [{:text=>'A',:url=>'/a'},{:text=>'S', :sub => [{:text=>'t1',:url=>'/t1'},{:text=>'t2',:url=>'/t2'}]}]
