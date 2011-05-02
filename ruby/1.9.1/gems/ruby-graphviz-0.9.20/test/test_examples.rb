require File.expand_path('support.rb', File.dirname(__FILE__))

class GraphVizTest < Test::Unit::TestCase

  #
  # you can run a subset of all the samples like this:
  #  ruby test/test_examples.rb  --name='/sample3[6-9]/'
  #
  # The above will run samples 36, 37, 38, and 39
  #


  include IoHack

  RootDir    = File.expand_path('../..', __FILE__)
  ExampleDir = File.join(RootDir,'examples')
  OutputDir  = File.join(File.dirname(__FILE__),'output')
  # OutputDir  = File.join(RootDir,'test','output')


  # the below tests write to stdout. the other tests write to filesystem

  Skips = {
    #'35' => 'hanging for me',
    '36' => 'hangs for me',
    '57' => 'will not be able to find the graphml script'
  }


  def test_sample07
    assert_output_pattern(/\Adigraph structs \{.+\}\n\Z/m, '07')
  end

  def test_sample22
    assert_output_pattern(/\Adigraph mainmap \{.+\}\n\Z/m, '22')
  end

  def test_sample23
    assert_output_pattern(%r{\A<map.+</map>\n\Z}m, '23')
  end

  def test_sample27
    assert_output_pattern(/\Adigraph G \{.*\}\n\Z/m, '27')
  end

  def test_sample33
    assert_output_pattern(/\Adigraph FamilyTree \{.+\}\n\Z/m, '33')
  end

  def test_sample38
    assert_output_pattern(/\Adigraph G \{.*\}\n\Z/m, '38')
  end

  def test_sample40
    assert_output_pattern(/\Adigraph G \{.*\}\n\Z/m, '40')
  end

  def test_sample55
    assert_output_pattern(/\Agraph G \{.*\}\n\Z/m, '55')
  end

  #
  # for every sample file in the examples directory that matches the
  # pattern ("sample01.rb, sample02.rb, etc) make a corresponding
  # test method: test_sample01(), test_sample02(), etc.  To actually define
  # this methods in this way instead of just iterating over the list of files
  # will make it easier to use command-line options to isolate certain
  # tests,
  #   (for example:   ruby test/test_examples.rb --name '/sample0[1-5]/' )
  # and to integrate better with certain kinds of test output and
  # reporting tools.
  #
  # we will skip over any methods already defined
  #

  @last_image_path = nil
  @number_to_path = {}
  class << self
    def make_sample_test_method path
      fail("failed match: #{path}") unless
        matches = %r{/(sample(\d\d))\.rb\Z}.match(path)
      basename, number = matches.captures
      number_to_path[number] = path
      meth = "test_#{basename}"
      return if method_defined?(meth)  # if we hand-write one
      if Skips[number]
        puts "skipping #{basename} - #{Skips[number]}"
        return
      end
      define_method(meth){ assert_sample_file_has_no_output(path) }
    end
    attr_accessor :last_image_path, :number_to_path
  end

  samples = Dir[File.join(ExampleDir,'sample*.rb')].sort
  samples.each {|path| make_sample_test_method(path) }


private

  def assert_output_pattern tgt_regexp, number
    path = self.class.number_to_path[number]
    setup_sample path
    out, err = fake_popen2(path)
    assert_equal "", err, "no errors"
    assert_match tgt_regexp, out.gsub(/\r\n/, "\n"), "output for sample#{number} should match regexp"
  end

  def assert_sample_file_has_no_output path
    setup_sample(path)
    begin
      out, err = fake_popen2(path)
      assert_equal(0, out.length, "expecting empty output")
      assert_equal(0, err.length, "expecting empty errorput")
      msg = "maybe generated #{self.class.last_image_path}"
      print "\n", msg
    rescue Exception => e
      assert(false, "got exception on #{File.basename(path)}: #{e.message}")
      puts "out: ", out.inspect, "err:", err.inspect
    end
  end

  def setup_sample path
    unless File.directory? OutputDir
      FileUtils.mkdir_p(OutputDir, :verbose => true)
    end
    ARGV[0] = nil if ARGV.any? # hack trigger searching for 'dot' executable
    hack_output_path path
  end

  def hack_output_path path
    # hack $0 to change where the output image is written to
    fake_example_path = File.join(OutputDir, File.basename(path))
    $program_name = fake_example_path.dup
    alias $0 $program_name
    self.class.last_image_path = "#{$0}.png"
  end
end
