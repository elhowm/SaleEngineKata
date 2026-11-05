# frozen_string_literal: true

RSpec.describe SaleEngine::Promos::BulkPrice do
  subject(:promo) { described_class.new("SR", threshold_quantity: 3, promo_price: Money.from_cents(450)) }

  let(:strawberries) { SaleEngine::Product.new(code: "SR", name: "Strawberries", price: Money.from_cents(500)) }
  let(:fruit_tea) { SaleEngine::Product.new(code: "FR", name: "Fruit Tea", price: Money.from_cents(311)) }

  describe "#product_code" do
    it { expect(promo.product_code).to eq("SR") }
  end

  describe "#apply?" do
    it "does not apply below the threshold" do
      expect(promo.apply?(strawberries, 2)).to be(false)
    end

    it "applies at the threshold" do
      expect(promo.apply?(strawberries, 3)).to be(true)
    end

    it "does not apply to another product" do
      expect(promo.apply?(fruit_tea, 3)).to be(false)
    end
  end

  describe "#discount" do
    it "is zero below the threshold" do
      expect(promo.discount(strawberries, 2)).to eq(Money.from_cents(0, "USD"))
    end

    it "is $1.50 for 3 items" do
      expect(promo.discount(strawberries, 3)).to eq(Money.from_cents(150, "USD"))
    end

    it "is $2.50 for 5 items" do
      expect(promo.discount(strawberries, 5)).to eq(Money.from_cents(250, "USD"))
    end

    it "is zero for another product" do
      expect(promo.discount(fruit_tea, 3)).to eq(Money.from_cents(0, "USD"))
    end

    it "returns Money in USD" do
      expect(promo.discount(strawberries, 3)).to be_a(Money).and have_attributes(currency: Money::Currency.new("USD"))
    end
  end

  describe "#description" do
    it { expect(promo.description(strawberries)).to eq("Strawberries x3 or more for $4.50.") }
  end
end
