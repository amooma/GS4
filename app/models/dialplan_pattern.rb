class DialplanPattern < ActiveRecord::Base
	
	has_many :dialplan_routes, :foreign_key => :pattern_id, :dependent => :restrict
	
	validates_presence_of   :pattern
	validate {
		
		require 'dialplan_pattern_matcher'
		
		begin
			dpp = DPP( :megaco_digitstring_mod, self.pattern )
			#puts "-----#{dpp.inspect}"
			if ! dpp
				errors.add( :type, :invalid )
			end
		rescue DialplanPatternMatcher::DialplanPatternInvalidError => e
			errors.add( :pattern, :invalid )
		end
	}
	
	validates_presence_of   :name, :allow_nil => false, :allow_blank => false
	validates_uniqueness_of :name, :allow_nil => false, :allow_blank => false
	
	
	
	
	
end
