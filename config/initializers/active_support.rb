#require 'erb'
require 'active_support/core_ext/string/output_safety.rb'

class ERB
	module Util
		
		# Fix ERB::Util in ActiveSupport in Rails to properly
		# escape "'" to "&apos;". (Erubis does that BTW.)
		# https://github.com/rails/rails/pull/275
		
		XML_ESCAPE = {
			'&' => '&amp;',
			'>' => '&gt;',
			'<' => '&lt;',
			'"' => '&quot;',
			"'" => '&apos;',
		}
		
		def xml_escape( s )
			s = s.to_s
			if s.html_safe?
				s
			else
				s.gsub(/[&"'><]/) { |c| XML_ESCAPE[c] }.html_safe
			end
		end
		
		remove_method(:x) if self.respond_to?(:x)
		alias :x :xml_escape
		module_function :x
		#singleton_class.send( :remove_method, :xml_escape )
		module_function :xml_escape
		
		remove_method(:html_escape) if self.respond_to?(:html_escape)
		alias :html_escape :xml_escape
		module_function :html_escape
		singleton_class.send( :remove_method, :xml_escape )
		module_function :xml_escape
		
		remove_method(:h) if self.respond_to?(:h)
		alias :h :html_escape
		module_function :h
		singleton_class.send(:remove_method, :html_escape)
		module_function :html_escape
		
	end
end

