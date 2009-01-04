require File.expand_path(File.join(File.dirname(__FILE__), %w[.. .. test_helper])) unless defined?(Juicer)

class TestCssDependencyResolver < Test::Unit::TestCase
  def setup
    @resolver = Juicer::Merger::CssDependencyResolver.new
    @file_setup = Juicer::Test::FileSetup.new($DATA_DIR)
    @file_setup.create!
  end

  def test_init
    assert_equal [], @resolver.files
  end

  def test_resolve
    b_file = File.expand_path(path('b.css'))
    a_file = File.expand_path(path('a.css'))

    files = @resolver.resolve(path('a.css')) do |file|
      assert b_file == file || a_file == file
      b_file != file
    end

    assert_equal [a_file], files

    files = @resolver.resolve(path('a.css')) do |file|
      assert b_file == file || a_file == file
      true
    end

    assert_equal [a_file, b_file], files.sort
  end
end