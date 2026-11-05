# frozen_string_literal: true

require "bundler/setup"
require_relative "lib/sale_engine"
require_relative "checkout_formatter"

promos = [
  SaleEngine::Promos::BuyOneGetOneFree.new("FR"),
  SaleEngine::Promos::BulkPrice.new("SR", threshold_quantity: 3, promo_price: Money.from_cents(450))
]
checkout = SaleEngine::Checkout.new(*promos)

puts "Enter product codes separated by spaces (e.g. FR SR CF):"
input = $stdin.gets.to_s
codes = input.split
codes.each { |code| checkout.scan(code) }

puts CheckoutFormatter.format(checkout)
