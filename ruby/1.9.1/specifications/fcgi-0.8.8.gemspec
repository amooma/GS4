# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fcgi}
  s.version = "0.8.8"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.autorequire = %q{fcgi}
  s.cert_chain = nil
  s.date = %q{2009-11-13}
  s.description = %q{FastCGI is a language independent, scalable, open extension to CGI that provides high performance without the limitations of server specific APIs. For more information, see http://www.fastcgi.com/.}
  s.extensions = ["ext/fcgi/extconf.rb"]
  s.files = ["lib/fcgi.rb", "ext/fcgi/extconf.rb", "ext/fcgi/fcgi.c", "ext/fcgi/MANIFEST", "ChangeLog", "README", "README.signals"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{fcgi}
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{FastCGI library for Ruby.}

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
