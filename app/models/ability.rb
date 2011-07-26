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
    
    user ||= User.new
    case user.role
      
      when "admin"
      (
        can    :read    , Home
        can    :manage  , Admin
        can    :manage  , User
        can    :manage  , SipAccount
        can    :read_title, SipAccount
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
        cannot :manage  , Phone
        can    :read    , Phone
        can    :edit    , Phone
        can    :create  , Phone
        can    :reboot  , Phone
        can    :read    , :Setup
      )
      
      when "cdr"
      (
        can    :read    , Home  # just a redirect_to( call_logs_path ) in the HomeController
        can    :read    , CallLog
      )
      
      when "user"
      (
        can    :read    , Home
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
        can    :read_title, SipAccount, :user_id => user.id
        can    :read , GlobalContact
        
        #can    :read    , FaxDocument #, :sip_account => { :user_id => user.id }
        #can    :create  , FaxDocument
        #TODO Once faxes are associated to SIP accounts or users, add check (in the controller) that users can't create FaxDocuments for other users.
        cannot :update  , FaxDocument
        
        can    :read    , CallLog, :sip_account => { :user_id => user.id }
        can    :read    , PersonalContact,  :user_id => user.id
        can    :new     , PersonalContact,  :user_id => user.id
        can    :create  , PersonalContact,  :user_id => user.id
        can    :update  , PersonalContact,  :user_id => user.id
        #FIXME User can change the user_id attribute. -- See abilities for CallForward.
        can    :destroy , PersonalContact,  :user_id => user.id
        cannot :edit_uid, PersonalContact
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

