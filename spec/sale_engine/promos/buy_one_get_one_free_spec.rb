# frozen_string_literal: true

RSpec.describe SaleEngine::Promos::BuyOneGetOneFree do
  subject(:promo) { described_class.new("FR") }

  let(:fruit_tea) { SaleEngine::Product.new(code: "FR", name: "Fruit Tea", price: Money.from_cents(311)) }
  let(:strawberries) { SaleEngine::Product.new(code: "SR", name: "Strawberries", price: Money.from_cents(500)) }

  describe "#product_code" do
    it { expect(promo.product_code).to eq("FR") }
  end

  describe "#apply?" do
    it "does not apply to a single item" do
      expect(promo.apply?(fruit_tea, 1)).to be(false)
    end

    it "applies to two items" do
      expect(promo.apply?(fruit_tea, 2)).to be(true)
    end

    it "does not apply to another product" do
      expect(promo.apply?(strawberries, 2)).to be(false)
    end
  end

  describe "#discount" do
    it "is zero for a single item" do
      expect(promo.discount(fruit_tea, 1)).to eq(Money.from_cents(0, "USD"))
    end

    it "is $3.11 for 2 items" do
      expect(promo.discount(fruit_tea, 2)).to eq(Money.from_cents(311, "USD"))
    end

    it "is $3.11 for 3 items" do
      expect(promo.discount(fruit_tea, 3)).to eq(Money.from_cents(311, "USD"))
    end

    it "is $6.22 for 4 items" do
      expect(promo.discount(fruit_tea, 4)).to eq(Money.from_cents(622, "USD"))
    end

    it "is zero for another product" do
      expect(promo.discount(strawberries, 2)).to eq(Money.from_cents(0, "USD"))
    end

    it "returns Money in USD" do
      expect(promo.discount(fruit_tea, 2)).to be_a(Money).and have_attributes(currency: Money::Currency.new("USD"))
    end
  end

  describe "#description" do
    it { expect(promo.description(fruit_tea)).to eq("Fruit Tea: buy one, get one free.") }
  end
end
