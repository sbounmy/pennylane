require "test_helper"
class CategoryGroupTest < Test::Unit::TestCase
  setup do
    Pennylane.api_key = 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs'
  end

  class ListTest < CategoryGroupTest
    test "#list" do
      groups = vcr { Pennylane::CategoryGroup.list }
      assert_equal 1, groups.count
      assert groups.first.categories.count > 10
    end

    test 'without api key raises error'  do
      Pennylane.api_key = nil
      assert_raises Pennylane::AuthenticationError do
        vcr { Pennylane::CategoryGroup.list }
      end
    end

    test 'can overwrite config api key' do
      Pennylane.api_key = nil
      groups = vcr { Pennylane::CategoryGroup.list({}, api_key: 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs') }
      assert_equal 1, groups.count
    end

    test 'accepts page and per_page' do
      list = vcr { Pennylane::CategoryGroup.list(per_page: 1, page: 2) }
      assert_equal 0, list.count
    end

    test 'can iterate' do
      vcr do
        Pennylane::CategoryGroup.list.each do |group|
          assert group.is_a? Pennylane::CategoryGroup
        end
      end
    end

    test 'has other attributes' do
      groups = vcr { Pennylane::CategoryGroup.list }
      assert_equal 1, groups.total_pages
      assert_equal 1, groups.total_category_groups
      assert_equal 1, groups.current_page
    end
  end
end