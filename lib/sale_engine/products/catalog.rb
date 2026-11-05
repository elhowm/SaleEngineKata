# frozen_string_literal: true

require "json"

module SaleEngine
  module Products
    # Products available in the store, loaded from a JSON file.
    class Catalog
      DEFAULT_PATH = File.expand_path("../../../config/products.json", __dir__)

      def initialize(path = DEFAULT_PATH)
        products_data = JSON.load_file(path)
        products = products_data.map { |product_data| build_product(product_data) }
        @products_by_code = products.to_h { |product| [product.code, product] }
      end

      def find(code)
        @products_by_code[code]
      end

      def products
        @products_by_code.values
      end

      private

      def build_product(product_data)
        Product.new(
          code: product_data.fetch("code"),
          name: product_data.fetch("name"),
          price: Money.from_cents(product_data.fetch("price_cents"))
        )
      end
    end
  end
end
