# Pennylane Ruby Library

The Pennylane Ruby library provides convenient access to the Pennylane API from applications written in the Ruby language. It includes a pre-defined set of classes for API resources that initialize themselves dynamically from API responses which makes it compatible with a wide range of versions of the Pennylane API.
It only works with the [buys and sales API](https://pennylane.readme.io/reference/versioning).

It was inspired by the [Stripe Ruby library](https://github.com/stripe/stripe-ruby).


## Documentation
See the [Pennylane API](https://pennylane.readme.io/reference/versioning) docs.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add pennylane

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install pennylane

## Requirements
Ruby 2.3+.

## Usage

The library needs to be configured with your account's token api which is available in your Pennylane Settings. Set `Pennylane.api_key` to its value:

```ruby
require 'pennylane'
Pennylane.api_key = 'x0fd....'

# list customers
Pennylane::Customer.list
```

### Customers ([API Doc](https://pennylane.readme.io/reference/customers-post-1))

```ruby
# filter and paginate customers
Pennylane::Customer.list(filter: [{field: 'name', operator: 'eq', value: 'Apple'}], page: 2)

# Retrieve single customer
Pennylane::Customer.retrieve('38a1f19a-256d-4692-a8fe-0a16403f59ff')

# Update a customer
cus = Pennylane::Customer.retrieve('38a1f19a-256d-4692-a8fe-0a16403f59ff')
cus.update(name: 'Apple Inc')

# Create a customer
Pennylane::Customer.create customer_type: 'company', name: 'Tesla', address: '4 rue du faubourg', postal_code: '75008', city: 'Paris', country_alpha2: 'FR'
```

### CustomerInvoices ([API Doc](https://pennylane.readme.io/reference/customer_invoices-import-1))

```ruby
# Create a customer invoice
Pennylane::CustomerInvoice.create(
  create_customer: true,
  create_products: true,
  invoice: {
    date: '2021-01-01',
    deadline: '2021-01-31',
    customer: {
      name: 'Tesla',
      customer_type: 'company',
      address: '4 rue du faubourg',
      postal_code: '75001',
      city: 'Paris',
      country_alpha2: 'FR',
      emails: ['stephane@tesla.com'] },
    line_items: [
      {
        description: 'Consulting',
        quantity: 1,
        unit_price: 1000
      }
    ]
  }
)

# List customer invoices
Pennylane::CustomerInvoice.list

# Retrieve a customer invoice
invoice = Pennylane::CustomerInvoice.retrieve('38a1f19a-256d-4692-a8fe-0a16403f59ff')

# Finalize a customer invoice
invoice.finalize

# Send a customer invoice
invoice.send_by_email

# Mark a customer invoice as paid
invoice.mark_as_paid

# Link an invoice and a credit note
credit_note = Pennylane::CustomerInvoice.retrieve('some-credit-note-id')
Pennylane::CustomerInvoice.links(invoice.quote_group_uuid, credit_note.quote_group_uuid)

# Import a customer invoice
Pennylane::CustomerInvoice.import(file: Util.file(File.expand_path('../fixtures/files/invoice.pdf', __FILE__)),
                                  create_customer: true,
                                  invoice: { date: Date.today, deadline: Date.today >> 1,
                                             customer: {
                                               name: 'Tesla',
                                               customer_type: 'company',
                                               address: '4 rue du faubourg',
                                               postal_code: '75001',
                                               city: 'Paris',
                                               country_alpha2: 'FR',
                                               emails: ['stephane@tesla.com'] },
                                             line_items: [
                                               {
                                                 description: 'Consulting',
                                                 quantity: 1,
                                                 unit_price: 1000
                                               }
                                             ]
                                  }
)
```
### Suppliers ([API Doc](https://pennylane.readme.io/reference/suppliers-post))

```ruby
# Create a supplier
Pennylane::Supplier.create(name: 'Apple Inc', address: '4 rue du faubourg', postal_code: '75008', city: 'Paris', country_alpha2: 'FR')

# Retrieve a supplier
Pennylane::Supplier.retrieve('supplier_id')

# List all suppliers
Pennylane::Supplier.list
```

### Products ([API Doc](https://pennylane.readme.io/reference/products-post-1))

```ruby
# Create a product
Pennylane::Product.create(label: 'Macbook Pro', unit: 'piece', price: 2_999, vat_rate: 'FR_200', currency: 'EUR')

# List all products
Pennylane::Product.list

# Retrieve a product
product = Pennylane::Product.retrieve('product_id')

# Update a product
product.update(label: 'Macbook Pro 2021')
```

### Categories ([API Doc](https://pennylane.readme.io/reference/tags-get))

```ruby
# Create a category
Pennylane::Category.create(name: 'IT')

# Retrieve a category
Pennylane::Category.retrieve('category_id')

# List all categories
Pennylane::Category.list

# Update a category
category = Pennylane::Category.retrieve('category_id')
category.update(name: 'IT Services')
```
### CategoryGroups ([API Doc](https://pennylane.readme.io/reference/tag-groups-get))
```ruby
# List all category groups
Pennylane::CategoryGroup.list
```

### Per-request api key
For apps that need to use multiple keys during the lifetime of a process. it's also possible to set a per-request key:
```ruby
require "pennylane"

Pennylane::Customer.list(
  {},
  {
    api_key: 'x1fa....'
  }
)

Pennylane::Customer.retrieve(
  '38a1f19a-256d-4692-a8fe-0a16403f59ff',
  {
    api_key: 'x1fa....'
  }
)

```


## Test mode
Pennylane provide a [test environment](https://help.pennylane.com/fr/articles/18773-creer-un-environnement-de-test). You can use the library with your test token api by setting the `Pennylane.api_key` to its value.


## Development

```bash
bundle install
bundle exec rake test
```

Resources implemented so far :
### CUSTOMER INVOICING

- Customer Invoices ✅
- Estimates 🚧
- Billing Subscriptions 🚧

### REFERENTIALS

- Customers ✅
- Suppliers ✅
- Categories ✅
- CategoryGroups ✅
- Products ✅
- Plan Items 🚧
- Enums 🚧

### SUPPLIER INVOICING
- Supplier Invoices 🚧

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sbounmy/pennylane. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/pennylane/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pennylane project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pennylane/blob/main/CODE_OF_CONDUCT.md).