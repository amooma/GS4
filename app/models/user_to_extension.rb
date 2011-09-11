class UserToExtension < ActiveRecord::Base
	
	belongs_to :extension, :dependent => :destroy
	belongs_to :user
	
	validates_uniqueness_of :extension_id
	
end
