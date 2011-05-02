#!/usr/bin/ruby

$:.unshift( "../../lib" );
require "graphviz"

GraphViz.new(:g){ |g|
  g[:center] = true
  a = g.add_node("A", :shape => "rgv_box", :peripheries => 0)
  b = g.add_node("Bonjour le monde\nComment va tu ?", :shape => "rgv_cloud", :peripheries => 0)
  c = g.add_node("C", :shape => "rgv_flower", :peripheries => 0)
  a << b << c
}.save( :ps => "#{$0}.ps", :extlib => "rgv.ps" )