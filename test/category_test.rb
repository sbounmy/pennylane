# frozen_string_literal: true

require "test_helper"

class CategoryTest < Test::Unit::TestCase
  setup do
    Pennylane.api_key = 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs'
  end
  class ListTest < CategoryTest
    test "#list" do
      categories = Pennylane::Category.list
      assert categories.count > 13
    end

    test 'without api key raises error'  do
      Pennylane.api_key = nil
      assert_raises Pennylane::AuthenticationError do
        Pennylane::Category.list
      end
    end

    test 'can overwrite config api key' do
      Pennylane.api_key = nil
      categories = Pennylane::Category.list({}, api_key: 'x0dFJzrOYxeJgzEddjT1agJl1K9T4C-kpjg7qpuKyEs')
      assert categories.count > 13
    end

    test 'accepts filter' do
      list = Pennylane::Category.list(filter: [{field: 'label', operator: 'eq', value: 'Virements internes'}])
      assert_equal 1, list.categories.count
      assert_equal "Virements internes", list.categories[0].label
    end

    test 'can iterate' do
      Pennylane::Category.list.each do |category|
        assert category.is_a? Pennylane::Category
      end
    end

    test 'has other attributes' do
      categories = Pennylane::Category.list
      assert categories.total_pages > 1
      assert categories.total_categories > 13
      assert_equal 1, categories.current_page
    end
  end

  class RetrieveTest < CategoryTest

    test 'raise error when not found' do
      assert_raises Pennylane::NotFoundError do
        Pennylane::Category.retrieve('not_found')
      end
    end

    test "return object when found" do
      cat = Pennylane::Category.retrieve('7a38e5f3-e523-40c6-a80b-79eddf943072')
      assert_equal 'Virements internes', cat.label
      assert_equal '7a38e5f3-e523-40c6-a80b-79eddf943072', cat.id
    end

    test "raise error on unknown attribute" do
      cat = Pennylane::Category.retrieve('7a38e5f3-e523-40c6-a80b-79eddf943072')
      assert_raises NoMethodError do
        cat.sexy_label
      end
    end
  end

  class CreateTest < CategoryTest
    test 'create category' do
      label = "New Category #{rand.to_s[2..10]}"
      category = Pennylane::Category.create group_source_id: 'bd4c493f-d4f4-4033-8505-8d95d8649fda', label: label
      expected = Pennylane::Category.list(filter: [{field: 'label', operator: 'eq', value: label}]).first
      assert_equal expected.source_id, category.source_id
      assert_equal label, expected.label
    end
  end

  class UpdateTest < CategoryTest
    test 'update category attributes' do
      postal_code = rand.to_s[2..6]
      before = Pennylane::Category.retrieve('7a38e5f3-e523-40c6-a80b-79eddf943072')
      before.update is_editable: true
      after = Pennylane::Category.retrieve('7a38e5f3-e523-40c6-a80b-79eddf943072')

      assert_equal before.source_id, after.source_id
      assert_equal 'Virements internes', after.label
      assert_equal true, after.is_editable
      assert_equal true, before.is_editable
    end

    test 'fails when trying to update restricted attribute' do
      omit 'should raise something if attributes if not defined but API does not return an error'
      before = Pennylane::Category.retrieve('c89d89d1-1b62-4777-9e37-d277116869bc')
      assert_raises NoMethodError do
        before.update unknown: 'something'
      end
    end
  end
end