# require 'active_record/connection_adapters/sqlite3_adapter'
# 
# ActiveRecord::ConnectionAdapters::SQLite3Adapter::class_eval {
# 	
# 	def quote( value, column = nil )
# 		if value.kind_of?(String) && column && column.type == :binary && column.class.respond_to?(:string_to_binary)
# 			s = column.class.string_to_binary(value).unpack("H*")[0]
# 			"x'#{s}'"
# 		else
# 			#####################{
# 			if value.kind_of?(String) && value.include?("\x00")
# 				raise ActiveRecord::ActiveRecordError.new( "ActiveRecord's SQLite adapter has a bug and does not escape \\x00 bytes." )
# 			end
# 			#####################}
# 			super
# 		end
# 	end
# 	
# }
# 
