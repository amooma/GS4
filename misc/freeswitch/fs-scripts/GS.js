
DIALPLAN_SERVICE_URL = 'http://127.0.0.1:80/freeswitch-call-processing/actions.xml';
//#OPTIMIZE We may want to use HTTPS. Maybe via a Stunnel.


LOG_DEBUG   = 1;
LOG_INFO    = 2;
LOG_NOTICE  = 3;
LOG_WARNING = 4;
LOG_ERROR   = 5;
LOG_CRIT    = 6;
LOG_ALERT   = 7;

function log( level, message )
{
	switch (level) {
		case LOG_DEBUG   : log_level_fs = 'debug'   ; break;
		case LOG_INFO    : log_level_fs = 'info'    ; break;
		case LOG_NOTICE  : log_level_fs = 'notice'  ; break;
		case LOG_WARNING : log_level_fs = 'warning' ; break;
		case LOG_ERROR   : log_level_fs = 'err'     ; break;
		case LOG_CRIT    : log_level_fs = 'crit'    ; break;
		default          : log_level_fs = 'alert'   ; break;
	}
	console_log( log_level_fs, message + "\n" );
}


try {
	if (! session) {
		// It's not a real call but "jsrun" from the console.
		throw new Error( "This script needs a session. Doesn't make sense to call it from the console." );
	}
	
	// Sets the auto hangup option forcing the session to terminate when the javascript terminates.
	session.setAutoHangup( true );
	
	session.setHangupHook( function ( hup_session, how ) {
		log( LOG_INFO, "Session "+ hup_session.name +" ended by "+ how +", ISUP cause: "+ hup_session.causecode +" ("+ hup_session.cause +")" );
		exit();
	});
	
	/*
	log( LOG_INFO,
		"session = {"
		+"\n            name : "+ session.name
		+"\n            uuid : "+ session.uuid
		//+"\n           state : "+ session.state
		+"\n             ani : "+ session.ani
		+"\n            ani2 : "+ session.ani2
		+"\n   caller_id_num : "+ session.caller_id_num
		+"\n  caller_id_name : "+ session.caller_id_name
		+"\n     destination : "+ session.destination
		+"\n    network_addr : "+ session.network_addr
		//+"\n        dialplan : "+ session.dialplan
		//+"\n           cause : "+ session.cause
		//+"\n       causecode : "+ session.causecode
		+"\n}"
	);
	*/
	log( LOG_INFO, '-----------------' );
	log( LOG_INFO, "Processing call from \""+ session.caller_id_num +"\" to \""+ session.destination +"\" ..." );
	
	function get_channel_info()
	{
		var chan_dump_str = apiExecute( 'uuid_dump', session.uuid );
		if (chan_dump_str.match( /^INVALID\s*COMMAND/i )) {
			return false;
		}
		if (chan_dump_str.match( /^-?ERR\s*No\s*Such\s*Channel/i )) {
			return false;
		}
		var chan_info = {};
		//var chan_vars = {};
		var re = /^([a-zA-Z_\-1-9]+)\s*:\s*([^\n\r]*)/mg;
		var re_variable = /^variable_/;
		var match;
		while (match = re.exec( chan_dump_str )) {
			var name = match[1];
			switch (name) {
				// Filter out the boring stuff. As we get the data
				// by calling "uuid_dump" some values don't tell us
				// much.
				// Also saves some 127 bytes on the wire (out of
				// about 3900, i.e. 3 %).
				case 'Event-Calling-File':          // 'mod_commands.c'
				case 'Event-Calling-Function':      // 'uuid_dump_function'
				case 'Event-Calling-Line-Number':   // '3834'
				case 'Caller-Dialplan':             // 'XML'
					continue;
			}
			var val;
			/*
			try {
				val = decodeURIComponent( match[2] );
			} catch (e if e instanceof URIError) {
				// decodeURIComponent() may complain about "malformed URI sequence".
			}
			*/
			val = unescape( match[2] );
			/*
			if (re_variable.test( name )) {
				name = name.replace( re_variable, '' );
				chan_vars[ name ] = val;
			} else {
				chan_info[ name ] = val;
			}
			*/
			if (re_variable.test( name )) {
				name = name.replace( re_variable, 'var_' );
				// By replacing "variable_" by "var_" we save
				// ("variable_".length - "var_".length) == 5 bytes
				// on the wire per variable. There are at least 67
				// vars, so we save 335 bytes (out of about 3900,
				// i.e. 8.5 %).
			}
			chan_info[ name ] = val;
		}
		//chan_info['vars'] = chan_vars;
		return chan_info;
	}
	
	var Hash = {
		to_query: function ( hash )
		{
			if ((typeof(hash)) != 'object') {
				//throw new Error( "Expected a hash ("+ (typeof(hash)) +" given)!" );
				return '';
			}
			var www_form_urlencoded = [];
			for (var prop in hash) {
				if (! hash.hasOwnProperty(prop)) continue;
				switch (typeof(hash[prop])) {
					case 'string':
						www_form_urlencoded.push(
							escape( prop         ).replace('%20','+') +
							'='+
							escape( hash[prop]   ).replace('%20','+')
						);
						break;
					/*
					case 'object':
						var hash1 = hash[prop];
						for (var prop1 in hash1) {
							if (! hash1.hasOwnProperty(prop1)) continue;
							www_form_urlencoded.push(
								escape( prop         ).replace('%20','+') +
								'[' +
								escape( prop1        ).replace('%20','+') +
								']=' +
								escape( hash1[prop1] ).replace('%20','+')
							);
						}
						break;
					*/
				}
			}
			return www_form_urlencoded.join('&');
		},
	};
	
	var DialplanService = {
		_curl: null,
		_url: DIALPLAN_SERVICE_URL,
		
		_load_curl: function()
		{
			if (! this._curl) {
				use( 'CURL' );
				if ((typeof CURL) == 'undefined') {
					// e.g. mod_spidermonkey_curl not loaded.
					throw new Error( "CURL is not available! (Did you load mod_spidermonkey_curl?)" );
				}
				this._curl = new CURL();
			}
		},
		
		request_actions: function()
		{
			log( LOG_DEBUG, "Requesting dialplan actions via HTTP ..." );
			this._load_curl();
			var query_data = Hash.to_query( get_channel_info() || {} );
			log( LOG_DEBUG, "Query data is "+ (query_data.length) +" bytes." );
			var buffer_obj = { data: '' };
			var t = (new Date()).getTime();
			this._curl.run(
				// HTTP-method, URL,
				'POST', this._url,
				query_data,  // encoded-query-string
				function ( string, arg ) {
					// Note: We want the arg to be passed by reference,
					// so it has to be an object instead of a scalar.
					try {
						if (arg.data.length == 0  // nothing received so far
						&&  string.length >= 5    // received something now
						&&  string.substr(0,5) != '<?xml'
						) {
							throw new Error( "Data is not XML!" );
						}
						// We get chunks of data.
						arg.data += string;
						return true;  // continue
					}
					catch (e) {
						// We need to take care of the logging here ourselves.
						log( LOG_ERROR, e.name +': '+ e.message +' in line '+ e.lineNumber );
						return false;  // abort CURL call
					}
				},              // callback
				buffer_obj,     // argument to the callback
				'',             // credentials ("user:password")
				8,              // timeout in seconds
				'application/x-www-form-urlencoded'  // Content-Type
			);
			t = (new Date()).getTime() - t;
			delete query_data;
			if (t < 1000) {
				log( LOG_INFO    , "Request to web service took "+ (t) +" ms." );
			} else if (t < 2000) {
				log( LOG_NOTICE  , "Request to web service took "+ (t) +" ms." );
			} else {
				log( LOG_WARNING , "Request to web service took "+ (t) +" ms." );
			}
			
			if (buffer_obj.data.length == 0) {
				throw new Error( "Did not receive any data." );
			}
			var curl_response_data = buffer_obj.data;
			// E4X XML() doesn't understand the XML processing instruction
			// nor whitespace at the beginning or end. :-(
			curl_response_data = curl_response_data
				.replace( /^<\?xml[^>]*\?>/, '' )
				.replace( /^\s*/, '' )
				.replace( /\s*$/, '' )
				;
			delete buffer_obj;
			
			if ((typeof XML) == 'undefined') {
				throw new Error( "E4X XML parser is not available!" );
			}
			try {
				var xml_obj = new XML( curl_response_data );
			}
			catch (e if e instanceof SyntaxError) {
				log( LOG_INFO, "Response from web service is:\n-----------------\n"+ curl_response_data +"\n-----------------" );
				log( LOG_ERROR, "XML error: "+ e.message );
				throw new Error( "Response is not valid XML!" );
			}
			if (xml_obj.name() != 'dialplan-actions') {
				throw new Error( "Expected root node \"dialplan-actions\" (got \""+ xml_obj.name() +"\")!" );
			}
			return xml_obj;
		},
		
		process_actions: function( dialplan_actions_xml_obj )
		{
			if (! dialplan_actions_xml_obj) {
				dialplan_actions_xml_obj = this.request_actions();
			}
			if ((typeof(dialplan_actions_xml_obj)) != 'xml') {
				throw new Error( "Expected an E4X XML object (got "+ (typeof(dialplan_actions_xml_obj)) +")!" );
			}
			
			var i = 0;
			var num_valid_actions = 0;
			var ret_do_continue_iterations = false;
			for each( var item in dialplan_actions_xml_obj.*) {
				if (! item.name()) continue;  // text node
				if (++i > 1000) {
					throw new Error( "Too many dialplan actions!" );
				}
				
				if (! session.ready()) {
					log( LOG_NOTICE, "Session has ended. Aborting dialplan execution." );
					break;
				}
				
				var tag_name = item.name().toString();
				//log( LOG_DEBUG, "Got element <"+ tag_name +">..." );
				// Note: It's probably safer to abort call processing
				// on invalid tags/attributes than to continue because
				// the service might send invalid elements in an
				// endless loop. That's why we throw exceptions here.
				switch (tag_name) {
					case 'action':
						var attr_appl = item.@application .toString();
						var attr_data = item.@data        .toString();
						log( LOG_DEBUG, '<'+ tag_name +' application="'+ attr_appl +'" data="'+ attr_data +'" />' );
						if (attr_appl == '') {
							throw new Error( "Missing attribute \"application\" in <"+ tag_name +"> tag!" );
						}
						switch (attr_appl) {
							case '_continue':
								// This is a safety precaution. We require an
								// explicit <action application="_continue" />
								// if the web service wants us to continue
								// the processing iterations, so we avoid
								// running an endless loop.
								ret_do_continue_iterations = true;
								break;
							default:
								if (! session.execute( attr_appl, attr_data )) {
									// Note: ok means that the application was found,
									// not that it executed successfully.
									throw new Error( "Dialplan application \""+ attr_appl +"\" not found!" );
								}
						}
						++num_valid_actions;
						break;
					default:
						throw new Error( "Unknown element <"+ tag_name +">!" );
						break;
				}
			}
			if (num_valid_actions == 0) {
				throw new Error( "Got 0 actions!" );
			}
			log( LOG_INFO, (ret_do_continue_iterations
				? 'Got "_continue" action.'
				: 'Did not get "_continue" action.'
			));
			return ret_do_continue_iterations;
		},
	};
	
	
	if (! session.ready()) {
		throw new Error( "Session is not ready!" );
	}
	else {
		session.setVariable( 'continue_on_fail', 'true' );
		session.setVariable( 'hangup_after_bridge', 'true' );
		
		//log( LOG_DEBUG, apiExecute( 'uuid_dump', session.uuid ) );
		//log( LOG_DEBUG, session.execute( 'info' ) );
		
		var num_requests = 0;
		while (session.ready()) {
			++num_requests;
			if (num_requests > 100) {
				throw new Error( "Too many dialplan requests!" );
			}
			log( LOG_INFO, "Dialplan actions, iteration "+ num_requests.toString() +" ..." );
			var do_continue_iterations = DialplanService.process_actions();
			if (! do_continue_iterations) break;
			session.execute( 'sleep', '500' );  // just to make sure the iterations are not too fast
		}
		log( LOG_INFO, "Done." );
	}
	exit();
}
catch (e) {
	/*
	//log( LOG_ERROR, (e.name != 'Error' ? e.name +": " : '') + e.message +" in "+ e.fileName +", line "+ e.lineNumber );
	// logged anyway by FreeSwitch when we re-throw the exception.
	if (session) {
		if (session.answered()) {
			session.hangup();
		} else {
			session.execute( 'respond', "500 Server Internal Error" );
		}
	}
	throw e;
	*/
	
	log( LOG_ERROR, (e.name != 'Error' ? e.name +": " : '') + e.message +" in "+ e.fileName +", line "+ e.lineNumber );
	// Fallback mode:
	log( LOG_WARNING, "Fallback mode ..." );
	dst = session.destination.replace( /^-kambridge-/, '' );
	session.execute( 'export', 'sip_contact_user=ufs' );
	session.execute( 'bridge', 'sofia/internal/'+dst+'@127.0.0.1' );
}

