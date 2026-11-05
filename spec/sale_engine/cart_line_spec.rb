# frozen_string_literal: true

RSpec.describe SaleEngine::CartLine do
  let(:fruit_tea) { SaleEngine::Product.new(code: "FR", name: "Fruit Tea", price: Money.from_cents(311)) }
  let(:strawberries) { SaleEngine::Product.new(code: "SR", name: "Strawberries", price: Money.from_cents(500)) }
  let(:coffee) { SaleEngine::Product.new(code: "CF", name: "Coffee", price: Money.from_cents(1123)) }

  let(:buy_one_get_one_free) { SaleEngine::Promos::BuyOneGetOneFree.new("FR") }
  let(:bulk_price) do
    SaleEngine::Promos::BulkPrice.new("SR", threshold_quantity: 3, promo_price: Money.from_cents(450))
  end

  describe "attributes" do
    subject(:cart_line) { described_class.new(product: fruit_tea, quantity: 3, promos: [buy_one_get_one_free]) }

    it "exposes product, quantity and promos" do
      expect(cart_line).to have_attributes(product: fruit_tea, quantity: 3, promos: [buy_one_get_one_free])
    end

    it "has no promos by default" do
      expect(described_class.new(product: fruit_tea, quantity: 1).promos).to eq([])
    end

    it "allows changing quantity and promos" do
      cart_line.quantity = 4
      cart_line.promos = []

      expect(cart_line).to have_attributes(quantity: 4, promos: [])
    end
  end

  context "without promos" do
    subject(:cart_line) { described_class.new(product: coffee, quantity: 2) }

    it "has the full price" do
      expect(cart_line.price).to eq(Money.from_cents(2246, "USD"))
    end

    it "has no discount" do
      expect(cart_line.discount).to eq(Money.from_cents(0, "USD"))
    end

    it "totals to the full price" do
      expect(cart_line.total).to eq(Money.from_cents(2246, "USD"))
    end
  end

  context "with buy one get one free" do
    subject(:cart_line) { described_class.new(product: fruit_tea, quantity: 3, promos: [buy_one_get_one_free]) }

    it "has the full price" do
      expect(cart_line.price).to eq(Money.from_cents(933, "USD"))
    end

    it "discounts one free item" do
      expect(cart_line.discount).to eq(Money.from_cents(311, "USD"))
    end

    it "totals to the price minus the discount" do
      expect(cart_line.total).to eq(Money.from_cents(622, "USD"))
    end
  end

  context "with bulk price" do
    subject(:cart_line) { described_class.new(product: strawberries, quantity: 3, promos: [bulk_price]) }

    it "discounts the price difference for each item" do
      expect(cart_line.discount).to eq(Money.from_cents(150, "USD"))
    end

    it "totals to the price minus the discount" do
      expect(cart_line.total).to eq(Money.from_cents(1350, "USD"))
    end
  end

  context "with several promos" do
    subject(:cart_line) { described_class.new(product: coffee, quantity: 1, promos: [first_promo, second_promo]) }

    let(:first_promo) { instance_double(SaleEngine::Promos::BulkPrice, discount: Money.from_cents(100)) }
    let(:second_promo) { instance_double(SaleEngine::Promos::BuyOneGetOneFree, discount: Money.from_cents(50)) }

    it "sums their discounts" do
      expect(cart_line.discount).to eq(Money.from_cents(150, "USD"))
    end
  end
end
