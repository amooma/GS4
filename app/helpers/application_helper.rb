module ApplicationHelper
  
  # Define the top navigation menu items
  #
  def top_menu_items
    if user_signed_in?
      menu_items = [
        { :text => "Admin"         , :url => admin_index_path },
        { :text => "Users"         , :url => admin_users_path },
        { :text => "Phones"        , :url => phones_path },
        { :text => "SIP Accounts"  , :url => sip_accounts_path },
        { :text => "Callforwards", :url => call_forwards_path },
        { :text => "Extensions"    , :url => extensions_path },
        { :text => "Conferences" , :url => conferences_path},
        { :text => "Servers"       , :sub => [
          { :text => "SIP Domains"          , :url => sip_servers_path },
          { :text => "SIP Proxies"          , :url => sip_proxies_path },
          { :text => "Voicemail Servers"    , :url => voicemail_servers_path },
          { :text => "Nodes"                , :url => nodes_path },
        ]},
      ]
    else
      menu_items = [
        { :text => "Sign in"       , :url => new_user_session_path }
      ]
    end
    return menu_items
  end
  
  def page_title( page_title )
    content_for(:page_title) { page_title }
  end
  
end

