# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-graphviz}
  s.version = "0.9.20"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gregoire Lejeune"]
  s.date = %q{2010-11-20}
  s.description = %q{Ruby/Graphviz provides an interface to layout and generate images of directed graphs in a variety of formats (PostScript, PNG, etc.) using GraphViz.}
  s.email = %q{gregoire.lejeune@free.fr}
  s.executables = ["ruby2gv", "gem2gv", "dot2ruby", "git2gv", "xml2gv"]
  s.extra_rdoc_files = ["README.rdoc", "COPYING", "AUTHORS"]
  s.files = ["COPYING", "README.rdoc", "AUTHORS", "setup.rb", "bin/dot2ruby", "bin/gem2gv", "bin/git2gv", "bin/ruby2gv", "bin/xml2gv", "examples/dot/balanced.dot", "examples/dot/cluster.dot", "examples/dot/dotgraph.dot", "examples/dot/fsm.dot", "examples/dot/genetic.dot", "examples/dot/hello.dot", "examples/dot/hello_test.rb", "examples/dot/lion_share.dot", "examples/dot/prof.dot", "examples/dot/psg.dot", "examples/dot/rank.dot", "examples/dot/sdh.dot", "examples/dot/siblings.dot", "examples/dot/so-sample001.gv", "examples/dot/so-sample002.gv", "examples/dot/so-sample003.gv", "examples/dot/test.dot", "examples/dot/test_parse.rb", "examples/dot/this_crach_with_dot_2.20.dot", "examples/dot/unix.dot", "examples/graphml/attributes.ext.graphml", "examples/graphml/attributes.graphml", "examples/graphml/cluster.graphml", "examples/graphml/hyper.graphml", "examples/graphml/nested.graphml", "examples/graphml/port.graphml", "examples/graphml/simple.graphml", "examples/hello.png", "examples/rgv/rgv.ps", "examples/rgv/test_rgv.rb", "examples/rgv/test_rgv.rb.ps", "examples/sample01.rb", "examples/sample02.rb", "examples/sample03.rb", "examples/sample04.rb", "examples/sample05.rb", "examples/sample06.rb", "examples/sample07.rb", "examples/sample08.rb", "examples/sample09.rb", "examples/sample10.rb", "examples/sample11.rb", "examples/sample12.rb", "examples/sample13.rb", "examples/sample14.rb", "examples/sample15.rb", "examples/sample16.rb", "examples/sample17.rb", "examples/sample18.rb", "examples/sample19.rb", "examples/sample20.rb", "examples/sample21.rb", "examples/sample22.rb", "examples/sample23.rb", "examples/sample24.rb", "examples/sample25.rb", "examples/sample26.rb", "examples/sample27.rb", "examples/sample28.rb", "examples/sample29.rb", "examples/sample30.rb", "examples/sample31.rb", "examples/sample32.rb", "examples/sample33.rb", "examples/sample34.rb", "examples/sample35.rb", "examples/sample36.rb", "examples/sample37.rb", "examples/sample38.rb", "examples/sample39.rb", "examples/sample40.rb", "examples/sample41.rb", "examples/sample42.rb", "examples/sample43.rb", "examples/sample44.rb", "examples/sample45.rb", "examples/sample46.rb", "examples/sample47.rb", "examples/sample48.rb", "examples/sample49.rb", "examples/sample50.rb", "examples/sample51.rb", "examples/sample52.rb", "examples/sample53.rb", "examples/sample54.rb", "examples/sample55.rb", "examples/sample56.rb", "examples/sample57.rb", "examples/sample58.rb", "examples/sample99.rb", "examples/sdlshapes/README", "examples/sdlshapes/sdl.ps", "examples/sdlshapes/sdlshapes.dot", "examples/simpsons.gv", "examples/test.xml", "examples/theory/pert.rb", "examples/theory/tests.rb", "lib/ext/gvpr/dot2ruby.g", "lib/graphviz/attrs.rb", "lib/graphviz/constants.rb", "lib/graphviz/core_ext.rb", "lib/graphviz/dot2ruby.rb", "lib/graphviz/edge.rb", "lib/graphviz/elements.rb", "lib/graphviz/ext.rb", "lib/graphviz/family_tree/couple.rb", "lib/graphviz/family_tree/generation.rb", "lib/graphviz/family_tree/person.rb", "lib/graphviz/family_tree/sibling.rb", "lib/graphviz/family_tree.rb", "lib/graphviz/graphml.rb", "lib/graphviz/math/matrix.rb", "lib/graphviz/node.rb", "lib/graphviz/nothugly/nothugly.xsl", "lib/graphviz/nothugly.rb", "lib/graphviz/theory.rb", "lib/graphviz/types/esc_string.rb", "lib/graphviz/types/gv_double.rb", "lib/graphviz/types/html_string.rb", "lib/graphviz/types/lbl_string.rb", "lib/graphviz/types.rb", "lib/graphviz/utils.rb", "lib/graphviz/xml.rb", "lib/graphviz.rb", "test/output/sample01.rb.png", "test/output/sample02.rb.png", "test/output/sample03.rb.png", "test/output/sample04.rb.png", "test/output/sample05.rb.png", "test/output/sample06.rb.png", "test/output/sample07.rb.png", "test/output/sample08.rb.png", "test/output/sample09.rb.png", "test/output/sample10.rb.png", "test/output/sample11.rb.png", "test/output/sample12.rb.png", "test/output/sample13.rb.png", "test/output/sample14.rb.png", "test/output/sample15.rb.png", "test/output/sample16.rb.png", "test/output/sample17.rb.png", "test/output/sample18.rb.png", "test/output/sample19.rb.png", "test/output/sample20.rb.png", "test/output/sample21.rb.html", "test/output/sample21.rb.png", "test/output/sample22.rb.html", "test/output/sample22.rb.png", "test/output/sample23.rb.png", "test/output/sample24.rb.png", "test/output/sample25.rb.png", "test/output/sample26.rb.png", "test/output/sample28.rb.png", "test/output/sample29.rb.svg", "test/output/sample30.rb.ps", "test/output/sample31.rb.png", "test/output/sample32.rb.png", "test/output/sample35.rb.gv", "test/output/sample35.rb.png", "test/output/sample37.rb.dot", "test/output/sample37.rb.png", "test/output/sample38.rb.png", "test/output/sample39.rb.png", "test/output/sample40.rb.png", "test/output/sample41.rb.svg", "test/output/sample42.rb.png", "test/output/sample43.rb.png", "test/output/sample44.rb.png", "test/output/sample45.rb.png", "test/output/sample46.rb.png", "test/output/sample47.rb.png", "test/output/sample48.rb.png", "test/output/sample49.rb.png", "test/output/sample50.rb.png", "test/output/sample51.rb.png", "test/output/sample52.rb.png", "test/output/sample53.rb.png", "test/output/sample54.rb.png", "test/output/sample55.rb.png", "test/output/sample56.rb.svg", "test/output/sample58.rb.png", "test/output/sample99.rb.png", "test/support.rb", "test/test_examples.rb", "test/test_init.rb"]
  s.homepage = %q{http://github.com/glejeune/Ruby-Graphviz}
  s.post_install_message = %q{
Since version 0.9.2, Ruby/GraphViz can use Open3.popen3 (or not)
On Windows, you can install 'win32-open3'

You need to install GraphViz (http://graphviz.org/) to use this Gem.

For more information about Ruby-Graphviz :
* Doc : http://rdoc.info/projects/glejeune/Ruby-Graphviz
* Sources : http://github.com/glejeune/Ruby-Graphviz
* NEW - Mailing List : http://groups.google.com/group/ruby-graphviz

/!\ Version 0.9.12 introduce a new solution to connect edges to node ports
For more information, see http://github.com/glejeune/Ruby-Graphviz/issues/#issue/13
So if you use node ports, maybe you need to change your code.

/!\ GraphViz::Node#name is deprecated and will be removed in version 1.0.0

/!\ :output and :file options are deprecated and will be removed in version 1.0.0

/!\ The html attribut is deprecated and will be removed in version 1.0.0
You can use the label attribut, as dot do it : :label => '<<html/>>'

/!\ Version 0.9.17 introduce GraphML (http://graphml.graphdrawing.org/) support and
graph theory !
}
  s.rdoc_options = ["--title", "Ruby/GraphViz", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ruby-asp}
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Interface to the GraphViz graphing tool}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
