begin
	settings = {
		:address               => Configuration.get( :smarthost_hostname, '127.0.0.1' ),
		:port                  => Configuration.get( :smarthost_port, 25, Integer ),
		:domain                => Configuration.get( :smarthost_domain, 'gemeinschaft.local' ),
		:user_name             => Configuration.get( :smarthost_username, '' ),
		:password              => Configuration.get( :smarthost_password, '' ),
		:authentication        => Configuration.get( :smarthost_authentication, 'plain' ),
		:enable_starttls_auto  => Configuration.get( :smarthost_enable_starttls_auto, true, Configuration::Boolean ),
	}

rescue ActiveRecord::StatementInvalid => e
	if ($0.to_s.match( /\b(rake)\b/ ) \
	&&  ::Object.const_defined?( :Rake ) \
	)
		#STDERR.puts "------#{Rake.application.top_level_tasks}"
		#STDERR.puts "------#{Rake.application.lookup( Rake.application.top_level_tasks.first ).prerequisites}"
		if [
			'db:schema:load',
			'db:setup',
			'db:migrate',
			'db:create',
		].include?( (Rake.application.top_level_tasks || []).first )
			
			STDERR.puts [
				"Could not get configuration from the database.",
				"Looks like you're just setting up the database,",
				"so no need to worry.",
			]
		end
	else
		raise e
	end
end

ActionMailer::Base.smtp_settings = settings || {}

