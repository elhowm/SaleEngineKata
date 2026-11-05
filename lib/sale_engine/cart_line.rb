# frozen_string_literal: true

module SaleEngine
  class CartLine
    attr_reader :product, :quantity, :promos

    def initialize(product:, quantity:, promos: [])
      @product = product
      @quantity = quantity
      @promos = promos
    end

    def price
      product.price * quantity
    end

    def discount
      discounts = promos.map { |promo| promo.discount(product, quantity) }
      discounts.sum(Money.zero)
    end

    def total
      price - discount
    end
  end
end
