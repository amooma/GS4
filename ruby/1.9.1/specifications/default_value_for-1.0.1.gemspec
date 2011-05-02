# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{default_value_for}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Hongli Lai"]
  s.date = %q{2010-11-08}
  s.description = %q{The default_value_for plugin allows one to define default values for ActiveRecord models in a declarative manner}
  s.email = %q{info@phusion.nl}
  s.files = ["default_value_for.gemspec", "LICENSE.TXT", "Rakefile", "README.rdoc", "test.rb", "init.rb", "lib/default_value_for.rb", "lib/default_value_for/railtie.rb", "lib/rails.rb"]
  s.homepage = %q{http://github.com/FooBarWidget/default_value_for}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Provides a way to specify default values for ActiveRecord models}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
