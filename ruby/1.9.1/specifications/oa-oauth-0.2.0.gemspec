# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{oa-oauth}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Bleigh"]
  s.date = %q{2011-03-11}
  s.description = %q{OAuth strategies for OmniAuth.}
  s.email = %q{michael@intridea.com}
  s.files = ["lib/oa-oauth.rb", "lib/omniauth/oauth.rb", "lib/omniauth/strategies/bitly.rb", "lib/omniauth/strategies/dailymile.rb", "lib/omniauth/strategies/doit.rb", "lib/omniauth/strategies/dopplr.rb", "lib/omniauth/strategies/evernote.rb", "lib/omniauth/strategies/facebook.rb", "lib/omniauth/strategies/foursquare.rb", "lib/omniauth/strategies/github.rb", "lib/omniauth/strategies/goodreads.rb", "lib/omniauth/strategies/google.rb", "lib/omniauth/strategies/gowalla.rb", "lib/omniauth/strategies/hyves.rb", "lib/omniauth/strategies/identica.rb", "lib/omniauth/strategies/instagram.rb", "lib/omniauth/strategies/instapaper.rb", "lib/omniauth/strategies/linked_in.rb", "lib/omniauth/strategies/meetup.rb", "lib/omniauth/strategies/miso.rb", "lib/omniauth/strategies/mixi.rb", "lib/omniauth/strategies/netflix.rb", "lib/omniauth/strategies/oauth.rb", "lib/omniauth/strategies/oauth2.rb", "lib/omniauth/strategies/smug_mug.rb", "lib/omniauth/strategies/sound_cloud.rb", "lib/omniauth/strategies/thirty_seven_signals.rb", "lib/omniauth/strategies/trade_me.rb", "lib/omniauth/strategies/trip_it.rb", "lib/omniauth/strategies/twitter.rb", "lib/omniauth/strategies/type_pad.rb", "lib/omniauth/strategies/vimeo.rb", "lib/omniauth/strategies/xauth.rb", "lib/omniauth/strategies/yahoo.rb", "lib/omniauth/strategies/you_tube.rb", "README.rdoc", "LICENSE"]
  s.homepage = %q{http://github.com/intridea/omniauth}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{OAuth strategies for OmniAuth.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oa-core>, ["= 0.2.0"])
      s.add_runtime_dependency(%q<multi_json>, ["~> 0.0.2"])
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.4.2"])
      s.add_runtime_dependency(%q<oauth>, ["~> 0.4.0"])
      s.add_runtime_dependency(%q<oauth2>, ["~> 0.1.1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<mg>, ["~> 0.0.8"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3.0"])
      s.add_development_dependency(%q<webmock>, ["~> 1.3.4"])
      s.add_development_dependency(%q<rack-test>, ["~> 0.5.4"])
      s.add_development_dependency(%q<json>, ["~> 1.4.3"])
      s.add_development_dependency(%q<evernote>, ["~> 0.9.0"])
    else
      s.add_dependency(%q<oa-core>, ["= 0.2.0"])
      s.add_dependency(%q<multi_json>, ["~> 0.0.2"])
      s.add_dependency(%q<nokogiri>, ["~> 1.4.2"])
      s.add_dependency(%q<oauth>, ["~> 0.4.0"])
      s.add_dependency(%q<oauth2>, ["~> 0.1.1"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<mg>, ["~> 0.0.8"])
      s.add_dependency(%q<rspec>, ["~> 1.3.0"])
      s.add_dependency(%q<webmock>, ["~> 1.3.4"])
      s.add_dependency(%q<rack-test>, ["~> 0.5.4"])
      s.add_dependency(%q<json>, ["~> 1.4.3"])
      s.add_dependency(%q<evernote>, ["~> 0.9.0"])
    end
  else
    s.add_dependency(%q<oa-core>, ["= 0.2.0"])
    s.add_dependency(%q<multi_json>, ["~> 0.0.2"])
    s.add_dependency(%q<nokogiri>, ["~> 1.4.2"])
    s.add_dependency(%q<oauth>, ["~> 0.4.0"])
    s.add_dependency(%q<oauth2>, ["~> 0.1.1"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<mg>, ["~> 0.0.8"])
    s.add_dependency(%q<rspec>, ["~> 1.3.0"])
    s.add_dependency(%q<webmock>, ["~> 1.3.4"])
    s.add_dependency(%q<rack-test>, ["~> 0.5.4"])
    s.add_dependency(%q<json>, ["~> 1.4.3"])
    s.add_dependency(%q<evernote>, ["~> 0.9.0"])
  end
end
