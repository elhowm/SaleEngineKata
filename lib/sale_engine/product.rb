# frozen_string_literal: true

module SaleEngine
  # A catalog product. `price` is a Money.
  Product = Data.define(:code, :name, :price)
end
