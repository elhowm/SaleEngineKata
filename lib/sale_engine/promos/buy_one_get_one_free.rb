# frozen_string_literal: true

module SaleEngine
  module Promos
    # Every second item of the product is free.
    class BuyOneGetOneFree
      attr_reader :product_code

      def initialize(product_code)
        @product_code = product_code
      end

      def apply?(product, quantity)
        product.code == product_code && quantity >= 2
      end

      def discount(product, quantity)
        return Money.zero(product.price.currency) unless apply?(product, quantity)

        product.price * (quantity / 2)
      end

      def description(product)
        "#{product.name}: buy one, get one free."
      end
    end
  end
end
