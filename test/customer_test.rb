# frozen_string_literal: true

require "test_helper"

class CustomerTest < Test::Unit::TestCase
  test "#list" do
    Pennylane.api_key = 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs'
    customers = Pennylane::Customer.list
    assert_equal 13, customers['customers'].count
    assert_equal 13, customers.customers.count
  end

  test '#list without api key raises error'  do
    Pennylane.api_key = nil
    assert_raises Pennylane::AuthenticationError do
      Pennylane::Customer.list
    end
  end

  test '#list can overwrite config api key' do
    Pennylane.api_key = nil
    customers = Pennylane::Customer.list({}, api_key: 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs')
    assert_equal 13, customers['customers'].count
  end

  test '#list accepts limit' do
    Pennylane.api_key = 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs'
    customers = Pennylane::Customer.list(filter: [{field: 'name', operator: 'eq', value: 'LUCKYSPACE'}].to_json)
    assert_equal 1, customers.customers.count
    assert_equal "LUCKYSPACE", customers.customers[0].name
  end
end