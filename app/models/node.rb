class Node < ActiveRecord::Base
	
	validates_presence_of     :management_host
	validate_hostname_or_ip   :management_host
	validates_uniqueness_of   :management_host, :case_sensitive => false, :scope => :management_port
	
	validate_ip_port          :management_port, :allow_nil => true
	validates_uniqueness_of   :management_port, :scope => :management_host
	
	validates_presence_of     :title
	validates_uniqueness_of   :title, :case_sensitive => false
	
end
