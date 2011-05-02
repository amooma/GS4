# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rails-erd}
  s.version = "0.4.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rolf Timmermans"]
  s.date = %q{2011-03-22}
  s.description = %q{Automatically generate an entity-relationship diagram (ERD) for your Rails models.}
  s.email = %q{r.timmermans@voormedia.com}
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = [".gemtest", "CHANGES.rdoc", "Gemfile", "Gemfile.lock", "LICENSE", "README.md", "Rakefile", "VERSION", "lib/rails-erd.rb", "lib/rails_erd.rb", "lib/rails_erd/diagram.rb", "lib/rails_erd/diagram/graphviz.rb", "lib/rails_erd/diagram/templates/node.html.erb", "lib/rails_erd/diagram/templates/node.record.erb", "lib/rails_erd/domain.rb", "lib/rails_erd/domain/attribute.rb", "lib/rails_erd/domain/entity.rb", "lib/rails_erd/domain/relationship.rb", "lib/rails_erd/domain/relationship/cardinality.rb", "lib/rails_erd/domain/specialization.rb", "lib/rails_erd/railtie.rb", "lib/rails_erd/tasks.rake", "rails-erd.gemspec", "test/test_helper.rb", "test/unit/attribute_test.rb", "test/unit/cardinality_test.rb", "test/unit/diagram_test.rb", "test/unit/domain_test.rb", "test/unit/entity_test.rb", "test/unit/graphviz_test.rb", "test/unit/rake_task_test.rb", "test/unit/relationship_test.rb", "test/unit/specialization_test.rb"]
  s.homepage = %q{http://rails-erd.rubyforge.org/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rails-erd}
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Entity-relationship diagram for your Rails models.}
  s.test_files = ["test/test_helper.rb", "test/unit/attribute_test.rb", "test/unit/cardinality_test.rb", "test/unit/diagram_test.rb", "test/unit/domain_test.rb", "test/unit/entity_test.rb", "test/unit/graphviz_test.rb", "test/unit/rake_task_test.rb", "test/unit/relationship_test.rb", "test/unit/specialization_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["~> 3.0"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.0"])
      s.add_runtime_dependency(%q<ruby-graphviz>, ["~> 0.9.18"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<jdbc-sqlite3>, [">= 0"])
      s.add_development_dependency(%q<activerecord-jdbc-adapter>, [">= 0"])
      s.add_development_dependency(%q<jruby-openssl>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, ["~> 3.0"])
      s.add_dependency(%q<activesupport>, ["~> 3.0"])
      s.add_dependency(%q<ruby-graphviz>, ["~> 0.9.18"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<jdbc-sqlite3>, [">= 0"])
      s.add_dependency(%q<activerecord-jdbc-adapter>, [">= 0"])
      s.add_dependency(%q<jruby-openssl>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, ["~> 3.0"])
    s.add_dependency(%q<activesupport>, ["~> 3.0"])
    s.add_dependency(%q<ruby-graphviz>, ["~> 0.9.18"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<jdbc-sqlite3>, [">= 0"])
    s.add_dependency(%q<activerecord-jdbc-adapter>, [">= 0"])
    s.add_dependency(%q<jruby-openssl>, [">= 0"])
  end
end
