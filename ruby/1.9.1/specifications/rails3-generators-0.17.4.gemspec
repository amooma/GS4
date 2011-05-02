# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rails3-generators}
  s.version = "0.17.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jose Valim", "Anuj Dutta", "Paul Berry", "Jeff Tucker", "Louis T.", "Jai-Gouk Kim", "Darcy Laycock", "Peter Haza", "Peter Gumeson", "Kristian Mandrup", "Alejandro Juarez"]
  s.date = %q{2011-02-02}
  s.description = %q{Rails 3 compatible generators for gems that don't have them yet }
  s.email = %q{andre@arko.net}
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG.rdoc"]
  s.files = [".gitignore", "CHANGELOG.rdoc", "Gemfile", "Gemfile.lock", "README.rdoc", "Rakefile", "lib/generators/active_model.rb", "lib/generators/active_model/model/model_generator.rb", "lib/generators/active_model/model/templates/model.rb", "lib/generators/authlogic.rb", "lib/generators/authlogic/session/session_generator.rb", "lib/generators/authlogic/session/templates/session.rb", "lib/generators/data_mapper.rb", "lib/generators/data_mapper/migration/migration_generator.rb", "lib/generators/data_mapper/migration/templates/migration.rb", "lib/generators/data_mapper/model/model_generator.rb", "lib/generators/data_mapper/model/templates/migration.rb", "lib/generators/data_mapper/model/templates/model.rb", "lib/generators/data_mapper/observer/observer_generator.rb", "lib/generators/data_mapper/observer/templates/observer.rb", "lib/generators/erubis.rb", "lib/generators/erubis/controller/controller_generator.rb", "lib/generators/erubis/controller/templates/view.html.erb", "lib/generators/erubis/scaffold/scaffold_generator.rb", "lib/generators/erubis/scaffold/templates/_form.html.erb", "lib/generators/erubis/scaffold/templates/edit.html.erb", "lib/generators/erubis/scaffold/templates/index.html.erb", "lib/generators/erubis/scaffold/templates/new.html.erb", "lib/generators/erubis/scaffold/templates/show.html.erb", "lib/generators/factory_girl.rb", "lib/generators/factory_girl/model/model_generator.rb", "lib/generators/factory_girl/model/templates/fixtures.1.rb", "lib/generators/factory_girl/model/templates/fixtures.2.rb", "lib/generators/formtastic.rb", "lib/generators/formtastic/scaffold/scaffold_generator.rb", "lib/generators/formtastic/scaffold/templates/_form.html.erb.erb", "lib/generators/formtastic/scaffold/templates/_form.html.haml.erb", "lib/generators/helpers/migration_helper.rb", "lib/generators/helpers/model_helper.rb", "lib/generators/koala.rb", "lib/generators/koala/install/install_generator.rb", "lib/generators/koala/install/templates/app/helpers/facebook_helper.rb.tt", "lib/generators/koala/install/templates/config/facebook.yml.tt", "lib/generators/koala/install/templates/config/initializers/koala.rb.tt", "lib/generators/mongo_mapper.rb", "lib/generators/mongo_mapper/.DS_Store", "lib/generators/mongo_mapper/install/install_generator.rb", "lib/generators/mongo_mapper/install/templates/database.mongo.yml", "lib/generators/mongo_mapper/install/templates/mongo_mapper.rb", "lib/generators/mongo_mapper/model/model_generator.rb", "lib/generators/mongo_mapper/model/templates/model.rb", "lib/generators/mongo_mapper/observer/observer_generator.rb", "lib/generators/mongo_mapper/observer/templates/observer.rb", "lib/generators/mustache.rb", "lib/generators/mustache/README.md", "lib/generators/mustache/controller/controller_generator.rb", "lib/generators/mustache/controller/templates/view.html.mustache.erb", "lib/generators/mustache/controller/templates/view.rb.erb", "lib/generators/mustache/install/install_generator.rb", "lib/generators/mustache/install/templates/config/initializers/mustache.rb", "lib/generators/mustache/install/templates/lib/mustache_rails.rb", "lib/generators/mustache/scaffold/scaffold_generator.rb", "lib/generators/mustache/scaffold/templates/_form.html.mustache.erb", "lib/generators/mustache/scaffold/templates/edit.html.mustache.erb", "lib/generators/mustache/scaffold/templates/edit.rb.erb", "lib/generators/mustache/scaffold/templates/index.html.mustache.erb", "lib/generators/mustache/scaffold/templates/index.rb.erb", "lib/generators/mustache/scaffold/templates/new.html.mustache.erb", "lib/generators/mustache/scaffold/templates/new.rb.erb", "lib/generators/mustache/scaffold/templates/show.html.mustache.erb", "lib/generators/mustache/scaffold/templates/show.rb.erb", "lib/generators/shoulda.rb", "lib/generators/shoulda/controller/controller_generator.rb", "lib/generators/shoulda/controller/templates/controller.rb", "lib/generators/shoulda/model/model_generator.rb", "lib/generators/shoulda/model/templates/model.rb", "lib/generators/simple_form.rb", "lib/generators/simple_form/scaffold/scaffold_generator.rb", "lib/generators/simple_form/scaffold/templates/_form.html.erb.erb", "lib/generators/simple_form/scaffold/templates/_form.html.haml.erb", "lib/rails3-generators.rb", "lib/rails3-generators/version.rb", "rails3-generators.gemspec", "test/fixtures/routes.rb", "test/lib/generators/active_model/model_generator_test.rb", "test/lib/generators/authlogic/session_generator_test.rb", "test/lib/generators/data_mapper/migration_generator_test.rb", "test/lib/generators/data_mapper/model_generator_test.rb", "test/lib/generators/data_mapper/observer_generator_test.rb", "test/lib/generators/erubis/controller_generator_test.rb", "test/lib/generators/erubis/scaffold_generator_test.rb", "test/lib/generators/factory_girl/model_generator_test.rb", "test/lib/generators/formtastic/scaffold_generators_test.rb", "test/lib/generators/koala/install_generator_test.rb", "test/lib/generators/mongo_mapper/install_generator_test.rb", "test/lib/generators/mongo_mapper/model_generator_test.rb", "test/lib/generators/mongo_mapper/observer_generator_test.rb", "test/lib/generators/mongo_mapper/testing_helper.rb", "test/lib/generators/mustache/controller_generator_test.rb", "test/lib/generators/mustache/scaffold_generator_test.rb", "test/lib/generators/mustache/testing_helper.rb", "test/lib/generators/shoulda/controller_generator_test.rb", "test/lib/generators/simple_form/scaffold_generators_test.rb", "test/test_helper.rb"]
  s.homepage = %q{https://github.com/indirect/rails3-generators}
  s.post_install_message = %q{
rails3-generators-0.17.4

Be sure to check out the wiki, https://wiki.github.com/indirect/rails3-generators/,
for information about recent changes to this project.

Machinist generators have been removed. Please update your project to use Machinist 2 (https://github.com/notahat/machinist) which contains its own generators.

Fabrication generators have been removed. Please update your project to use Fabrication (https://github.com/paulelliott/fabrication) which contains its own generators.

Mongoid generators have been removed. Please update your project to use Mongoid (https://github.com/mongoid/mongoid) which contains its own generators.
}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rails3-generators}
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Rails 3 compatible generators}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.0.0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<test-unit>, [">= 0"])
      s.add_development_dependency(%q<haml-rails>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 3.0.0"])
      s.add_development_dependency(%q<factory_girl>, [">= 0"])
    else
      s.add_dependency(%q<railties>, [">= 3.0.0"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<test-unit>, [">= 0"])
      s.add_dependency(%q<haml-rails>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<factory_girl>, [">= 0"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.0.0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<test-unit>, [">= 0"])
    s.add_dependency(%q<haml-rails>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<factory_girl>, [">= 0"])
  end
end
