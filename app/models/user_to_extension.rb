class UserToExtension < ActiveRecord::Base
	
	#OPTIMIZE Implementieren wie besprochen. Siehe Message-ID: <4E676272.1070805@amooma.de> vom 07 Sep 2011 14:24:18 +0200.
	# https://groups.google.com/group/amooma-dev/browse_frm/thread/6da97e3f6ea72559/f4240c71f9b95950?tvc=1#f4240c71f9b95950
	# D.h. die Tabelle "users_to_vfax_extensions" oder
	# "users_to_faxbox_extensions" nennen und das Model entsprechend.
	# So ist nicht klar warum User zu Extensions eine direkte
	# Verbindung haben obwohl es schon eine Verbindung über die
	# SIP-Accounts gibt.
	
	belongs_to :extension, :dependent => :destroy
	belongs_to :user
	
	validates_uniqueness_of :extension_id
	
end
