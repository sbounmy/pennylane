require 'test_helper'

class Pennylane::ClientTest < Test::Unit::TestCase

  def client(key='x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs')
    Pennylane::Client.new(key)
  end

  class RequestTest < Pennylane::ClientTest
    test "works on get" do
      resp = vcr { client.request(:get, '/customers', params: { body: {} }) }

      obj = JSON.parse(resp.read_body)
      assert obj['total_customers'] > 19
    end

    test "works on get with params" do
      resp = vcr { client.request(:get, '/customers', params: { body: { page: 2 } }) }

      obj = JSON.parse(resp.read_body)
      assert_equal 2, obj['current_page']
    end

    test "works on post" do
      customer_params = { customer_type: 'company', name: 'Tesla', address: '4 rue du faubourg', postal_code: '75008', city: 'Paris', country_alpha2: 'FR' }
      resp = vcr { client.request(:post, '/customers', params: { body: { customer: customer_params } }) }

      obj = JSON.parse(resp.read_body)
      assert_equal 'Tesla', obj['customer']['name']
    end

    test "works on put" do

    end

    test 'raise AuthenticationError when wrong key' do
      assert_raises Pennylane::AuthenticationError do
        vcr { client('blabla').request(:get, '/customers') }
      end
    end

    test 'raise Not found error when missing resource' do
      assert_raises Pennylane::NotFoundError do
        vcr { client.request(:get, '/customers/123') }
      end
    end

    test 'raise error when wrong url' do
      assert_raises Pennylane::NotFoundError do
        vcr { client.request(:get, '/something') }
      end
    end
  end
end