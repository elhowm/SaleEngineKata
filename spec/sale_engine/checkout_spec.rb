# frozen_string_literal: true

RSpec.describe SaleEngine::Checkout do
  subject(:checkout) { described_class.new(buy_one_get_one_free, bulk_price) }

  let(:buy_one_get_one_free) { SaleEngine::Promos::BuyOneGetOneFree.new("FR") }
  let(:bulk_price) do
    SaleEngine::Promos::BulkPrice.new("SR", threshold_quantity: 3, promo_price: Money.from_cents(450))
  end

  describe "#scan" do
    it "returns true for a known code" do
      expect(checkout.scan("FR")).to be(true)
    end

    it "returns false for an unknown code" do
      expect(checkout.scan("XX")).to be(false)
    end
  end

  describe "#total" do
    context "with README examples" do
      it "is $22.45 for FR SR FR FR CF" do
        %w[FR SR FR FR CF].each { |code| checkout.scan(code) }

        expect(checkout.total).to eq(Money.from_cents(2245, "USD"))
      end

      it "is $3.11 for FR FR" do
        %w[FR FR].each { |code| checkout.scan(code) }

        expect(checkout.total).to eq(Money.from_cents(311, "USD"))
      end

      it "is $16.61 for SR SR FR SR" do
        %w[SR SR FR SR].each { |code| checkout.scan(code) }

        expect(checkout.total).to eq(Money.from_cents(1661, "USD"))
      end

      it "is $27.84 for SR SR FR FR SR CF" do
        %w[SR SR FR FR SR CF].each { |code| checkout.scan(code) }

        expect(checkout.total).to eq(Money.from_cents(2784, "USD"))
      end
    end

    it "is zero for an empty cart" do
      expect(checkout.total).to eq(Money.from_cents(0, "USD"))
    end

    it "charges full price without promos" do
      checkout = described_class.new
      %w[FR FR].each { |code| checkout.scan(code) }

      expect(checkout.total).to eq(Money.from_cents(622, "USD"))
    end

    it "ignores unknown codes" do
      %w[FR XX].each { |code| checkout.scan(code) }

      expect(checkout.total).to eq(Money.from_cents(311, "USD"))
    end
  end
end
