# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simple_form}
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["José Valim", "Carlos Antônio"]
  s.date = %q{2011-02-06}
  s.description = %q{Forms made easy!}
  s.email = %q{contact@plataformatec.com.br}
  s.files = [".gitignore", ".gitmodules", "CHANGELOG.rdoc", "Gemfile", "Gemfile.lock", "MIT-LICENSE", "README.rdoc", "Rakefile", "init.rb", "lib/generators/simple_form/USAGE", "lib/generators/simple_form/install_generator.rb", "lib/generators/simple_form/templates/_form.html.erb", "lib/generators/simple_form/templates/_form.html.haml", "lib/generators/simple_form/templates/en.yml", "lib/generators/simple_form/templates/simple_form.rb", "lib/simple_form.rb", "lib/simple_form/action_view_extensions/builder.rb", "lib/simple_form/action_view_extensions/form_helper.rb", "lib/simple_form/components.rb", "lib/simple_form/components/errors.rb", "lib/simple_form/components/hints.rb", "lib/simple_form/components/label_input.rb", "lib/simple_form/components/labels.rb", "lib/simple_form/components/placeholders.rb", "lib/simple_form/components/wrapper.rb", "lib/simple_form/error_notification.rb", "lib/simple_form/form_builder.rb", "lib/simple_form/has_errors.rb", "lib/simple_form/i18n_cache.rb", "lib/simple_form/inputs.rb", "lib/simple_form/inputs/base.rb", "lib/simple_form/inputs/block_input.rb", "lib/simple_form/inputs/boolean_input.rb", "lib/simple_form/inputs/collection_input.rb", "lib/simple_form/inputs/date_time_input.rb", "lib/simple_form/inputs/hidden_input.rb", "lib/simple_form/inputs/mapping_input.rb", "lib/simple_form/inputs/numeric_input.rb", "lib/simple_form/inputs/priority_input.rb", "lib/simple_form/inputs/string_input.rb", "lib/simple_form/map_type.rb", "lib/simple_form/version.rb", "simple_form.gemspec", "test/action_view_extensions/builder_test.rb", "test/action_view_extensions/form_helper_test.rb", "test/components/error_test.rb", "test/components/hint_test.rb", "test/components/label_test.rb", "test/components/wrapper_test.rb", "test/error_notification_test.rb", "test/form_builder_test.rb", "test/inputs_test.rb", "test/simple_form_test.rb", "test/support/misc_helpers.rb", "test/support/mock_controller.rb", "test/support/mock_response.rb", "test/support/models.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/plataformatec/simple_form}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{simple_form}
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Forms made easy!}
  s.test_files = ["test/action_view_extensions/builder_test.rb", "test/action_view_extensions/form_helper_test.rb", "test/components/error_test.rb", "test/components/hint_test.rb", "test/components/label_test.rb", "test/components/wrapper_test.rb", "test/error_notification_test.rb", "test/form_builder_test.rb", "test/inputs_test.rb", "test/simple_form_test.rb", "test/support/misc_helpers.rb", "test/support/mock_controller.rb", "test/support/mock_response.rb", "test/support/models.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
