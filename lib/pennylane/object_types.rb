module Pennylane
  module ObjectTypes
    def self.object_names_to_classes
      {
        ListObject.object_name => ListObject,
        Category.object_name => Category,
        CategoryGroup.object_name => CategoryGroup,
        Customer.object_name => Customer,
        CustomerInvoice.object_name => CustomerInvoice,
        Product.object_name => Product,
        Supplier.object_name => Supplier
      }.freeze
    end
  end
end