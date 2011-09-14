class PhoneModel < ActiveRecord::Base
  
  default_value_for :max_number_of_sip_accounts, 1
  
  default_value_for :number_of_keys, 0
  default_value_for :ssl, false
  default_value_for :http_port, 80
  default_value_for :http_request_timeout, 5
  default_value_for :random_password_length, 8
  default_value_for :random_password_consists_of, ((0 ..9).to_a + ('A'..'Z').to_a + ('a'..'z').to_a).join
  
  # Validations
  #
  validates_presence_of :name
  
  validates_presence_of     :manufacturer_id
  validates_numericality_of :manufacturer_id, :only_integer => true
  
  validates_presence_of     :max_number_of_sip_accounts
  validates_numericality_of :max_number_of_sip_accounts, :only_integer => true, :greater_than_or_equal_to => 1
  
  validates_presence_of     :number_of_keys
  validates_numericality_of :number_of_keys, :only_integer => true, :greater_than_or_equal_to => 0
  
  validates_presence_of     :random_password_length
  validates_numericality_of :random_password_length, :only_integer => true, :greater_than_or_equal_to => 0
  
  validates_presence_of     :random_password_consists_of
  validates_length_of       :random_password_consists_of, :minimum => 1
  
  validate :does_a_manufacturer_to_this_phone_model_exist
  validate :validate_url
  validate :validate_max_number_of_sip_accounts_for_an_existing_phone_model
  validate :validate_number_of_keys_for_an_existing_phone_model
  
  # Associations
  #
  belongs_to :manufacturer
  has_many :phone_model_keys, :order => 'position', :dependent => :destroy
  
  has_many :phone_model_mac_addresses, :dependent => :destroy
  has_many :phones, :dependent => :destroy
  
  has_many :phone_model_codecs, :order => 'position', :dependent => :destroy
  has_many :codecs, :through => :phone_model_codecs
  
  # Find a phone_model by a given MAC Address
  #
  def self.find_by_mac_address(mac_address)
    phone_model = nil
    if !(
       mac_address.class != String \
    || mac_address == nil \
    || mac_address.blank? \
    || mac_address.upcase.gsub(/[^A-F0-9]/,'').length > 12 \
    || mac_address.upcase.gsub(/[^A-F0-9]/,'').length < 7 \
    )
      mac_address = mac_address.upcase.gsub(/[^A-F0-9]/,'')
      (6 .. mac_address.length).each do |length|
        phone_model_mac_addresses = PhoneModelMacAddress.where(:starts_with => mac_address[0,length])
          phone_model = PhoneModel.where(:id => phone_model_mac_addresses.first.phone_model_id).first if !phone_model_mac_addresses.first.nil?
        break if !phone_model.nil?
      end
    end
    phone_model
  end
  
  # Generate a random password for a Phone of this PhoneModel
  #
  def random_new_password
    if self.random_password_length == 0
      nil
    else
      new_password = String.new
      for i in 0 .. self.random_password_length
         new_password += self.random_password_consists_of.scan(/./).sort_by {rand}.first
      end
      new_password
    end
  end
  
  private
  
  # Validates if the phone model has a manufacturer.
  def does_a_manufacturer_to_this_phone_model_exist
    if ! Manufacturer.exists?(:id => self.manufacturer_id)
      errors.add(:manufacturer_id, I18n.t(:no_maufacturer_with_id, :id => self.manufacturer_id))
    end      
  end
  
  # Validates the URL.
  def validate_url()
    if !self.url.blank?
      require 'uri'
      begin
        uri = URI.parse( self.url )
        if ! uri.absolute?
          errors.add( :url, I18n.t(:invalid_no_scheme))
        elsif ! uri.hierarchical?
          errors.add( :url, I18n.t(:invalid_not_hierarchical))
        elsif !( uri.is_a?( URI::HTTP ) || uri.is_a?( URI::HTTPS ) )
          errors.add( :url, I18n.t(:invalid_no_http_scheme))
        end
      rescue URI::InvalidURIError
        errors.add( :url, I18n.t(:invalid))
      end
    end
  end
  
  # Validates the number of sip_accounts on a phone_model
  # If you change the number of maximum sip_accounts on an already
  # existing model the system checks if there are any phones with 
  # more than that in the system.
  def validate_max_number_of_sip_accounts_for_an_existing_phone_model
    if ! self.new_record? and self.changed_attributes.keys.include?('max_number_of_sip_accounts') \
    && self.max_number_of_sip_accounts < PhoneModel.find(self.id).max_number_of_sip_accounts
      if self.max_number_of_sip_accounts.to_i < ( self.phones.collect {|phone| phone.sip_accounts.count}.max || 0 )
        errors.add( :max_number_of_sip_accounts, I18n.t(:phones_with_more_sip_accounts_exist, :sip_accounts => self.max_number_of_sip_accounts))
      end
    end
  end
  
  # Validates the number of number_of_keys on a phone_model
  # If you change the number number_of_keys on an already
  # existing model the system checks if there are any phones with 
  # more than that in the system.
  def validate_number_of_keys_for_an_existing_phone_model
    if ! self.new_record? \
    && self.changed_attributes.keys.include?('number_of_keys') \
    && self.number_of_keys < PhoneModel.find(self.id).number_of_keys
      sip_accounts = self.phones.collect {|phone| phone.sip_accounts}.flatten
      number_of_used_keys = sip_accounts.collect {|sip_account| sip_account.phone_keys}.flatten.collect {|phone_key| phone_key.phone_model_key_id}.uniq.count
      if number_of_used_keys > self.number_of_keys
        errors.add( :number_of_keys, I18n.t(:phones_with_more_keys_exist, :keys => self.number_of_keys))
      end
      if self.phone_model_keys.count > self.number_of_keys
        errors.add( :number_of_keys, I18n.t(:more_phone_model_keys_exist, :keys => self.number_of_keys))
      end
    end
  end
  
end
