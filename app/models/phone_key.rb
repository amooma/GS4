class PhoneKey < ActiveRecord::Base
  belongs_to :sip_account
  belongs_to :phone_model_key
  belongs_to :phone_key_function_definition
  has_many :sip_accounts

  validates_presence_of      :value
  
  validates_presence_of      :phone_model_key_id
  validates_numericality_of  :phone_model_key_id, :only_integer => true
  
  validates_presence_of      :phone_key_function_definition_id
  validates_numericality_of  :phone_key_function_definition_id, :only_integer => true
  
  # is this a good way?:
  #validates_presence_of      :phone_key_function_definition
  
  validates_presence_of      :sip_account_id
  validates_numericality_of  :sip_account_id, :only_integer => true
  
  validate :validate_softkey
  validate :key_must_be_a_possible_key_from_the_phone_model
  validate :phone_key_function_definition_must_be_valid
  validate :phone_model_keys_has_to_be_available
  validate :sip_account_must_belong_to_phone

  private
  
  # Validates the softkey definition.
  def validate_softkey
    if self.phone_key_function_definition == nil
      errors.add( :phone_key_function_definition, "cannot be nil." )
    else
      case self.phone_key_function_definition.type_of_class
        when 'string'
          if ! self.value.class.ancestors.include?( String )
	    errors.add( :value, "(\"#{self.value}\") for \"#{self.phone_key_function_definition.name}\" softkey has to be a string." )
          end
        when 'integer'
          if ! self.value.match( /^\-?[0-9]{1,9}$/ )
	    errors.add( :value, "(\"#{self.value}\") for \"#{self.phone_key_function_definition.name}\" softkey has to be numerical." )
          end
        when 'boolean'
          if ! self.value.match( /^(?:true|false)$/ )
	    errors.add( :value, "(\"#{self.value}\") for \"#{self.phone_key_function_definition.name}\" softkey has to be boolean (\"true\" or \"false\")." )
          end
        when 'url'
          require 'uri'
	    begin
	      uri = URI.parse( self.value )
	      # Require an absolute URI (i.e. with a scheme):
	      if ! uri.absolute?
	        errors.add( :value, "(\"#{self.value}\") for \"#{self.phone_key_function_definition.name}\" softkey has to be an URL with a scheme." )
	      end
	      rescue URI::InvalidURIError
	        errors.add( :value, "(\"#{self.value}\") for \"#{self.phone_key_function_definition.name}\" softkey has to be an URL." )
	    end
	when 'uri'
          require 'uri'
	    begin
	      uri = URI.parse( self.value )
	      # Strictly speaking, if the thing has a fragment ("#frag")
	      # then it's not a "URI" (but maybe a "URI-reference").
	      if ! uri.fragment.nil?
	        errors.add( :value, "(\"#{self.value}\") for \"#{self.phone_key_function_definition.name}\" softkey has to be an URI (URI's don't have a fragment)." )
	      end
	      rescue URI::InvalidURIError
		errors.add( :value, "(\"#{self.value}\") for \"#{self.phone_key_function_definition.name}\" softkey has to be an URI." )
	    end
		    
	    else
	      errors.add( :'phone_key_function_definition.type_of_class',
	        "(\"#{self.phone_key_function_definition.type_of_class}\") is not validatable for softkey function type \"#{self.phone_key_function_definition.name}\"." )
      end
      if ! self.phone_key_function_definition.regex_validation.blank?
        re = Regexp.new( self.phone_key_function_definition.regex_validation )
        if ! re.match( self.value )
          errors.add( :value, "(\"#{self.value}\") does not match the required format for softkey function type \"#{self.phone_key_function_definition.name}\"." )
        end
      end
    end
  end
  
  # Checks if this key is a valid key from the phone_model
  #
  def key_must_be_a_possible_key_from_the_phone_model
    phone_model = self.sip_account.phone.phone_model
    if !phone_model.phone_model_keys.exists?(self.phone_model_key_id)
      errors.add( :phone_model_key_id, "Is not a valid PhoneModelKey for the PhoneModel #{phone_model.name} (ID #{phone_model.id})." )
    end
  end
  
  # Checks if the phone_key_function_definition is valid for 
  # the given PhoneModelKey
  #
  def phone_key_function_definition_must_be_valid
    if !self.sip_account.phone.phone_model.phone_model_keys.first.phone_key_function_definitions.exists?(self.phone_key_function_definition_id)
      errors.add( :phone_key_function_definition_id, "Is not a valid phone_key_function_definition for the PhoneModelKey ID #{self.phone_model_key_id}." )
    end
  end
  # Does this SipAccount belong to this phone
  def sip_account_must_belong_to_phone
    if self.sip_account.id != self.sip_account_id
      errors.add( :sip_account_id, "Is not a valid sip account for this phone." )
    end
  end
  # Checks that a key is available
  #
  def phone_model_keys_has_to_be_available
    self.sip_account.undefined_phone_model_keys.include?(self.phone_model_key)
  end
end
