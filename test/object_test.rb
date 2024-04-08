require 'test_helper'

class Pennylane::ObjectTest < Test::Unit::TestCase
  class InitializeFromResponseTest < Pennylane::ObjectTest
    test "initialize correctly from response with array" do
      obj = Pennylane::Object.new.initialize_from_response({
        total_pages: 1,
        total_customers: 2,
        customers: [Pennylane::Object.build_from({ id: 'cus1'}), Pennylane::Object.build_from({ id: 'cus2' })]
     })
      assert_equal 1, obj.total_pages
      assert_equal 2, obj.total_customers
      assert_equal ['cus1', 'cus2'], obj.customers.map(&:id)
    end

  end
end