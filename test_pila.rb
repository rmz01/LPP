require 'test/unit'
require_relative '../lib/pila'

class TestPila < Test::Unit::TestCase
  def test_sum
    assert_equal(4, sum(2, 2), "sum(2, 2) debería devolver 4")
    assert_equal(5, sum(2, 2), "sum(2, 3) debería devolver 5")
  end

  def test_fibonacci
    assert_equal(0, fibonacci(0), "fibonacci(0) debería devolver 0")
    assert_equal(1, fibonacci(1), "fibonacci(1) debería devolver 1")
    assert_equal(5, fibonacci(5), "fibonacci(5) debería devolver 5")
    assert_equal(8, fibonacci(6), "fibonacci(6) debería devolver 8")
  end
end
