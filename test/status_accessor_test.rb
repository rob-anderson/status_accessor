require 'lib/status_accessor'
require 'test/unit'

class StatusAccessorTest < Test::Unit::TestCase

  class Test1
    extend StatusAccessor
    status_accessor :cheese, :ham
  end
  class Test2
    extend StatusAccessor
    status_accessor :chalk
  end

  def test_statuses_are_unique_to_classes
    assert_equal ['CHEESE', 'HAM'], Test1.status_strings
    assert_equal ['CHALK'], Test2.status_strings
    assert_equal ['CHEESE', 'HAM'], Test1.status_strings # reading the Test2 definition hasn't overwritten class variable
  end

  def test_status_strings_provdes_cloned_instance
    assert_equal ['Any', 'CHEESE', 'HAM'], Test1.status_strings.unshift('Any')
    assert_equal ['CHEESE', 'HAM'], Test1.status_strings
  end

  class Valve
    extend StatusAccessor
    attr_accessor :status
    status_accessor :open, :closed
  end

  def test_setters_and_getters_work_as_expected
    v = Valve.new
    v.open!
    assert_equal 'OPEN', v.status
    v.closed!
    assert_equal 'CLOSED', v.status
    assert v.closed?
    assert !v.open?
  end

  class Chameleon
    attr_accessor :colour
    extend StatusAccessor
    status_accessor :colour, [:red, :blue, :green]
  end

  def test_default_status_field_name_can_be_overwritten
    assert_equal %w{RED BLUE GREEN}, Chameleon.colour_strings
    c = Chameleon.new
    c.blue!
    assert_equal 'BLUE', c.colour
    assert c.blue?
  end

  class Camel
    attr_accessor :hump
    extend StatusAccessor
    status_accessor :hump, [:single_hump, :double_hump], :transform => :capitalize
  end

  def status_formatting_can_be_set_via_a_transform_option
    c = Camel.new
    c.single_hump!
    assert_equal "Single_hump", c.hump
  end

  class MockedActiveRecord
    class << self
      @@nops = []
      def named_scope name, options
        @@nops << [name, options]
      end
      def named_scopes
        @@nops
      end
    end
    extend StatusAccessor
    status_accessor :ham, :spam
  end

  def test_named_scopes
    assert_equal [:ham, {:conditions => {:status => 'HAM'}}], MockedActiveRecord.named_scopes.first
  end

end

