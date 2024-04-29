## [Unreleased]

## [1.0.0] - 2024-04-29

- Support CustomerInvoice:
  - `finalize`
  - `mark_as_paid`
  - `send_by_email`
  - `links`
  - `import`
- Support per request `api_key` e.g `Pennylane::Customer.retrieve('cus_id', {api_key: 'x0fd....'})`
- Endpoints returning empty response we are doing +1 GET request at the resource. Not the best solution but at least we are sure we have fresh data.
- Added resource properties access with `#[]` e.g `cus['name']`

## [0.2.0-alpha] - 2024-04-20

- Support resources 
  - `CategoryGroup`
  - `Category` 
  - `Product`
- Added missing `#create` to `Supplier`
- Adding `#update` to `Customer` and `Supplier`


## [0.1.0] - 2024-04-04

- Initial release