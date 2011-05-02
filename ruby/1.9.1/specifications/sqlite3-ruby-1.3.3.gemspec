# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sqlite3-ruby}
  s.version = "1.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jamis Buck", "Luis Lavena", "Aaron Patterson"]
  s.date = %q{2011-01-16}
  s.default_executable = %q{sqlite3_ruby}
  s.description = %q{This module allows Ruby programs to interface with the SQLite3
database engine (http://www.sqlite.org).  You must have the
SQLite engine installed in order to build this module.

Note that this module is NOT compatible with SQLite 2.x.}
  s.email = ["jamis@37signals.com", "luislavena@gmail.com", "aaron@tenderlovemaking.com"]
  s.executables = ["sqlite3_ruby"]
  s.extra_rdoc_files = ["Manifest.txt", "CHANGELOG.rdoc", "README.rdoc"]
  s.files = ["CHANGELOG.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "bin/sqlite3_ruby", "lib/sqlite3/dummy.rb"]
  s.homepage = %q{http://github.com/luislavena/sqlite3-ruby}
  s.post_install_message = %q{
#######################################################

Hello! The sqlite3-ruby gem has changed it's name to just sqlite3.  Rather than
installing `sqlite3-ruby`, you should install `sqlite3`.  Please update your
dependencies accordingly.

Thanks from the Ruby sqlite3 team!

<3 <3 <3 <3

#######################################################

}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sqlite3-ruby}
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{This module allows Ruby programs to interface with the SQLite3 database engine (http://www.sqlite.org)}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sqlite3>, [">= 1.3.3"])
      s.add_development_dependency(%q<hoe>, [">= 2.8.0"])
    else
      s.add_dependency(%q<sqlite3>, [">= 1.3.3"])
      s.add_dependency(%q<hoe>, [">= 2.8.0"])
    end
  else
    s.add_dependency(%q<sqlite3>, [">= 1.3.3"])
    s.add_dependency(%q<hoe>, [">= 2.8.0"])
  end
end
