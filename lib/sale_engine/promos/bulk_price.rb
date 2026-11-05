# frozen_string_literal: true

module SaleEngine
  module Promos
    # Buying threshold_quantity or more drops the price of each item to promo_price.
    class BulkPrice
      attr_reader :product_code, :threshold_quantity, :promo_price

      def initialize(product_code, threshold_quantity:, promo_price:)
        @product_code = product_code
        @threshold_quantity = threshold_quantity
        @promo_price = promo_price
      end

      def apply?(product, quantity)
        product.code == product_code && quantity >= threshold_quantity
      end

      def discount(product, quantity)
        return Money.zero(product.price.currency) unless apply?(product, quantity)

        (product.price - promo_price) * quantity
      end

      def description(product)
        "#{product.name} x#{threshold_quantity} or more for #{promo_price.format}."
      end
    end
  end
end
