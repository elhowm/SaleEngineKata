# frozen_string_literal: true

RSpec.describe SaleEngine::Products::Catalog do
  let(:fruit_tea) { SaleEngine::Product.new(code: "FR", name: "Fruit Tea", price: Money.from_cents(311)) }
  let(:strawberries) { SaleEngine::Product.new(code: "SR", name: "Strawberries", price: Money.from_cents(500)) }

  context "with a products file" do
    subject(:catalog) { described_class.new(File.expand_path("../../fixtures/products.json", __dir__)) }

    describe "#find" do
      it "returns the product for a known code" do
        expect(catalog.find("FR")).to eq(fruit_tea)
      end

      it "returns another product for its code" do
        expect(catalog.find("SR")).to eq(strawberries)
      end

      it "returns nil for an unknown code" do
        expect(catalog.find("XX")).to be_nil
      end
    end

    describe "#products" do
      it "returns all products in file order" do
        expect(catalog.products).to eq([fruit_tea, strawberries])
      end
    end
  end

  context "with the default products file" do
    subject(:catalog) { described_class.new }

    let(:coffee) { SaleEngine::Product.new(code: "CF", name: "Coffee", price: Money.from_cents(1123)) }
    let(:apple_juice) { SaleEngine::Product.new(code: "AJ", name: "Apple Juice", price: Money.from_cents(725)) }

    it "loads the store products" do
      expect(catalog.products).to eq([fruit_tea, strawberries, coffee, apple_juice])
    end
  end
end
