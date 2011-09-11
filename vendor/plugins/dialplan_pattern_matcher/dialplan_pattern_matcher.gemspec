require File.expand_path( '../lib/dialplan_pattern_matcher/version', __FILE__ )
require 'date'

Gem::Specification.new do |gem|
	gem.name        = 'dialplan_pattern_matcher'
	#gem.version     = '0.0.1'
	gem.version     = DialplanPatternMatcher::VERSION
	gem.platform    = Gem::Platform::RUBY
	gem.author      = "Philipp Kempgen"
	gem.email       = 'philipp.kempgen@localhost'
	#gem.homepage    = 'http://github.com/user/your_gem'
	gem.summary     = "Dialplan pattern matcher"
	gem.description = "Provides means to match dialstrings against dialplan patterns."
	gem.date        = Date.today.to_s
	
	gem.add_development_dependency( 'rake' )
	gem.add_development_dependency( 'test-unit' )
	#gem.add_development_dependency( 'rspec', ['>= 2.0.0'] )
	
	gem.add_dependency( 'activesupport', '~> 3.0.0' )
	
	gem.files = Dir[ '{lib,test}/**/*', 'README*', 'LICENSE*', 'Rakefile' ]
	gem.require_path = 'lib'
end


# Local Variables:
# mode: ruby
# indent-tabs-mode: t
# End:
