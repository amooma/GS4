class DialplanRoute < ActiveRecord::Base
	
	belongs_to :dialplan_pattern, :foreign_key => :pattern_id, :validate => true
	belongs_to :user
	belongs_to :sip_gateway
	
	
	validates_format_of   :eac, :with => /\A[0-9*#]*\z/,
		:allow_nil => false, :allow_blank => false
	
	# pattern_id
	validates_presence_of   :dialplan_pattern
	
	# user_id
	validates_presence_of   :user, :if => Proc.new { |me| me.user_id }
	
	# sip_gateway_id
	validates_presence_of   :sip_gateway, :if => Proc.new { |me| me.sip_gateway_id }
	
	# position
	validates_numericality_of :position, :only_integer => true, :allow_nil => true
	
	acts_as_list
	
	
	def match( dialstring, current_user_id )
		begin
			dialstring = dialstring.to_s.dup
			
			# Match user:
			(! self.user_id || self.user_id == current_user_id) || (
				return { :match => false, :reason => :user_mismatch }
			)
			
			# Match EAC:
			eac = self.eac.to_s
			(eac == dialstring[ 0, eac.length ]) || (
				return { :match => false, :reason => :eac_mismatch }
			)
			
			# Cut-off EAC:
			phone_number = dialstring[ eac.length, (dialstring.length - eac.length) ].to_s
			
			# Match pattern:
			(self.dialplan_pattern) || (
				# Should never happen.
				return { :match => false, :reason => :no_pattern }
			)
			pattern_does_match = self.dialplan_pattern.match( phone_number )
			(pattern_does_match) || (
				return { :match => false, :reason => :pattern_mismatch }
			)
			
			# Pattern matches.
			return { :match => true, :reason => nil, :opts => { :number => phone_number } }
			
		rescue => e
			return { :match => false, :reason => :exception }
		end
	end
	
end
