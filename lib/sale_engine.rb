# frozen_string_literal: true

require "money"

Money.default_currency = "USD"
Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.locale_backend = :currency

require_relative "sale_engine/product"
require_relative "sale_engine/promos/buy_one_get_one_free"
require_relative "sale_engine/promos/bulk_price"
require_relative "sale_engine/products/catalog"
require_relative "sale_engine/cart_line"
require_relative "sale_engine/checkout"
