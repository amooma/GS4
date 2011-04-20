class Manufacturer < ActiveRecord::Base
  has_many :phone_models, :order => :name, :dependent => :destroy
  has_many :ouis, :dependent => :destroy
  has_many :phones, :through => :phone_models
  validates_presence_of :name
  validates_uniqueness_of :name
end
