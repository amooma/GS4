class DialplanRoute < ActiveRecord::Base
	
	belongs_to :dialplan_pattern, :foreign_key => :pattern_id, :validate => true
	belongs_to :user
	belongs_to :sip_gateway
	
	
	validates_format_of   :eac, :with => /\A[0-9]*\z/,
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
	
	
	
	
	
	
end
