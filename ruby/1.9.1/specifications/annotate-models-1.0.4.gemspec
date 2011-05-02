# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{annotate-models}
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dave Thomas"]
  s.date = %q{2008-09-04}
  s.default_executable = %q{annotate}
  s.description = %q{Add a comment summarizing the current schema to the top of each ActiveRecord model source file}
  s.email = ["ctran@pragmaquest.com"]
  s.executables = ["annotate"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "website/index.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "config/hoe.rb", "config/requirements.rb", "lib/annotate_models.rb", "lib/annotate_models/version.rb", "lib/annotate_models/tasks.rb", "lib/tasks/annotate.rake", "log/debug.log", "script/destroy", "script/generate", "script/txt2html", "bin/annotate", "setup.rb", "tasks/deployment.rake", "tasks/environment.rake", "tasks/website.rake", "test/test_annotate_models.rb", "test/test_helper.rb", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.rhtml"]
  s.homepage = %q{http://annotate-models.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{annotate-models}
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Add a comment summarizing the current schema to the top of each ActiveRecord model source file}
  s.test_files = ["test/test_annotate_models.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
