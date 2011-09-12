class Ability
  include CanCan::Ability
  
  def initialize( user )
  (
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    
    #OPTIMIZE Create an alias so :destroy includes :confirm_destroy ?
    # https://github.com/ryanb/cancan/wiki/Action-Aliases
    #alias_action :destroy, :confirm_destroy, :to => :destroy
    
    user ||= User.new
    case user.role
      
      when "admin"
      (
        can    :read    , Home
        can    :manage  , Admin
        can    :manage  , User
        can    :manage  , SipAccount
        can    :read_title, SipAccount
        cannot :have    , SipAccount
        can    :manage  , CallForward
        can    :manage  , Extension
        can    :manage  , CallQueue
        can    :manage  , Conference
        can    :manage  , FaxDocument
        can    :manage  , SipServer
        can    :manage  , SipProxy
        can    :manage  , VoicemailServer
        can    :manage  , Node
        can    :manage  , PersonalContact
        can    :edit_uid, PersonalContact
        can    :manage  , GlobalContact
        can    :manage  , Configuration
        can    :manage  , SipGateway
        can    :manage  , DialplanPattern
        can    :manage  , DialplanRoute
        
        cannot :destroy , User do |u|
          u.try(:id) == user.id
        end
        cannot :manage  , CallLog
        cannot :update  , FaxDocument
        cannot :manage  , Authentication
        cannot :manage  , Manufacturer
        can    :read    , Manufacturer
        cannot :manage  , PhoneModel
        can    :read    , PhoneModel
        can    :manage  , Phone
        can    :read    , :Setup
        can    :read    , Voicemail
        can    :destroy , Voicemail
        can    :confirm_destroy , Voicemail
        can    :create  , NetworkSetting
        can    :read    , NetworkSetting
        can    :edit    , NetworkSetting
        can    :update  , NetworkSetting
        can    :edit    , PinChange, :user_id => user.id
        can    :update  , PinChange, :user_id => user.id
        #FIXME User can change the user_id attribute.(?) -- See abilities for CallForward.
      )
      
      when "cdr"
      (
        can    :read    , Home  # just a redirect_to( call_logs_path ) in the HomeController
        can    :read    , CallLog
        #OPTIMIZE Add PinChange?
        cannot :have    , SipAccount
      )
      
      when "user"
      (
        can    :read    , Home
        
        can    :have    , SipAccount
        
        can    :read    , CallForward, :sip_account => { :user_id => user.id }
        can    :new     , CallForward
        can    :create  , CallForward do |call_forward|
          if call_forward.try(:sip_account) == nil
            # error handled in the model
            true
          else
            call_forward.try(:sip_account).try(:user_id) == user.id \
            && user.id != nil
          end
        end
        can    :update  , CallForward do |call_forward|
          call_forward.try(:sip_account).try(:user_id) == user.id \
          && user.id != nil
        end
        can    :destroy , CallForward do |call_forward|
          call_forward.try(:sip_account).try(:user_id) == user.id \
          && user.id != nil
        end
        #OPTIMIZE Missing can    :confirm_destroy , CallForward do ... ?
        can    :read_title, SipAccount, :user_id => user.id
        can    :read    , GlobalContact
        
        can    :read    , FaxDocument, :user_id => user.id 
        can    :create  , FaxDocument, :user_id => user.id
        can    :destroy , FaxDocument, :user_id => user.id
        cannot :update  , FaxDocument
        
        can    :read    , CallLog, :sip_account => { :user_id => user.id }
        can    :read    , PersonalContact, :user_id => user.id
        can    :new     , PersonalContact, :user_id => user.id
        can    :create  , PersonalContact, :user_id => user.id
        can    :update  , PersonalContact, :user_id => user.id
        #FIXME User can change the user_id attribute. -- See abilities for CallForward.
        can    :destroy , PersonalContact, :user_id => user.id
        can    :confirm_destroy , PersonalContact, :user_id => user.id
        cannot :edit_uid, PersonalContact
        
        can    :read    , Voicemail
        can    :destroy , Voicemail
        can    :confirm_destroy , Voicemail
        
        can    :read,     Conference, :user_id => user.id
        can    :read,     Conference, :user_id => nil
        can    :edit,     Conference, :user_id => user.id
        can    :update  , Conference, :user_id => user.id
        #FIXME User can change the user_id attribute. -- See abilities for CallForward.
        cannot :edit_uid, Conference
        
        can    :edit    , PinChange, :user_id => user.id
        can    :update  , PinChange, :user_id => user.id
        #FIXME User can change the user_id attribute.(?) -- See abilities for CallForward.
      )
      
      else
      (
        # guest user (not logged in)
        
        can    :read    , :Setup
        can    :create  , :Setup
        can    :new     , :Password
        can    :create  , :Password
      )
      
    end
    
  )end
end

