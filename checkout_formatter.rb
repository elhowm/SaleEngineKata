# frozen_string_literal: true

class CheckoutFormatter
  class << self
    def format(checkout)
      positions = checkout.cart.map { |cart_line| format_position(cart_line) }
      promos = checkout.cart.flat_map { |cart_line| format_promos(cart_line) }

      output = ["Positions:", *positions]
      output += ["Promos applied:", *promos] if promos.any?
      output << "Total: #{checkout.total.format}"
      output.join("\n")
    end

    private

    def format_position(cart_line)
      position = "- #{cart_line.product.name} x#{cart_line.quantity} | #{cart_line.price.format}"
      return position if cart_line.promos.empty?

      "#{position} - #{cart_line.discount.format} (promo)"
    end

    def format_promos(cart_line)
      cart_line.promos.map { |promo| "- #{promo.description(cart_line.product)}" }
    end
  end
end
