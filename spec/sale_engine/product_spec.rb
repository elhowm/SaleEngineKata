# frozen_string_literal: true

RSpec.describe SaleEngine::Product do
  subject(:product) { described_class.new(code: "FR", name: "Fruit Tea", price: Money.from_cents(311)) }

  it "exposes its attributes" do
    expect(product).to have_attributes(code: "FR", name: "Fruit Tea", price: Money.from_cents(311))
  end

  it "is equal to another product with the same values" do
    expect(product).to eq(described_class.new(code: "FR", name: "Fruit Tea", price: Money.from_cents(311)))
  end

  it "is not equal to a product with different values" do
    expect(product).not_to eq(described_class.new(code: "FR", name: "Fruit Tea", price: Money.from_cents(300)))
  end

  it "is immutable" do
    expect(product).to be_frozen
  end
end
