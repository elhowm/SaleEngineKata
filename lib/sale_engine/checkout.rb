# frozen_string_literal: true

module SaleEngine
  class Checkout
    def initialize(*promos, catalog: Products::Catalog.new)
      @promos = promos
      @catalog = catalog
      @cart = []
    end

    def scan(code)
      product = @catalog.find(code)
      return false unless product

      cart_line = find_or_init_cart_line(product)
      cart_line.quantity += 1
      recalc_promos!(cart_line)
      true
    end

    def total
      line_totals = @cart.map(&:total)
      line_totals.sum(Money.zero)
    end

    private

    def find_or_init_cart_line(product)
      cart_line = @cart.find { it.product == product }
      return cart_line if cart_line

      new_cart_line = CartLine.new(product:, quantity: 0)
      @cart << new_cart_line
      new_cart_line
    end

    def recalc_promos!(cart_line)
      cart_line.promos = @promos.select { it.apply?(cart_line.product, cart_line.quantity) }
    end
  end
end
