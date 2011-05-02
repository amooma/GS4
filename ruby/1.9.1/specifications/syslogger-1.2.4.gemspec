# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{syslogger}
  s.version = "1.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3") if s.respond_to? :required_rubygems_version=
  s.authors = ["Cyril Rohr"]
  s.date = %q{2011-02-08}
  s.description = %q{Same as SyslogLogger, but without the ridiculous number of dependencies and with the possibility to specify the syslog facility}
  s.email = ["cyril.rohr@gmail.com"]
  s.files = ["lib/syslogger.rb", "spec/spec_helper.rb", "spec/syslogger_spec.rb", "Rakefile", "LICENSE", "README.rdoc"]
  s.homepage = %q{http://github.com/crohr/syslogger}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8")
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Dead simple Ruby Syslog logger}
  s.test_files = ["spec/spec_helper.rb", "spec/syslogger_spec.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 0.8"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3"])
    else
      s.add_dependency(%q<rake>, ["~> 0.8"])
      s.add_dependency(%q<rspec>, ["~> 1.3"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 0.8"])
    s.add_dependency(%q<rspec>, ["~> 1.3"])
  end
end
