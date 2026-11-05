# frozen_string_literal: true

require "money"

Money.default_currency = "USD"
Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.locale_backend = :currency

require_relative "../lib/sale_engine/product"
require_relative "../lib/sale_engine/promos/buy_one_get_one_free"
require_relative "../lib/sale_engine/promos/bulk_price"
require_relative "../lib/sale_engine/products/catalog"
require_relative "../lib/sale_engine/cart_line"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
