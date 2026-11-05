---
name: ruby-code-style
description: Ruby and RSpec code style preferences for this project. Use when writing or refactoring Ruby code in lib/ or specs in spec/.
---

# Ruby code style

## Flat steps, no Russian-doll expressions

Write a computation as a sequence of steps, one per line, each result assigned to a well-named
local variable. Don't nest calls and blocks inside each other so the reader has to unpack them
from the inside out.

- One step per line: read, then transform, then collect. Name each intermediate result.
- If a block would need several lines (e.g. building an object), move that work into a small
  private method so the step stays one line.

Bad: reading, parsing, building and collecting all nested in one expression:

```ruby
def initialize(path = DEFAULT_PATH)
  @products_by_code = JSON.parse(File.read(path)).to_h do |attributes|
    product = Product.new(
      code: attributes.fetch("code"),
      name: attributes.fetch("name"),
      price: Money.from_cents(attributes.fetch("price_cents"))
    )
    [product.code, product]
  end
end
```

Good: three named steps, with construction moved out to a private method:

```ruby
def initialize(path = DEFAULT_PATH)
  products_data = JSON.load_file(path)
  products = products_data.map { |product_data| build_product(product_data) }
  @products_by_code = products.to_h { |product| [product.code, product] }
end

private

def build_product(product_data)
  Product.new(
    code: product_data.fetch("code"),
    name: product_data.fetch("name"),
    price: Money.from_cents(product_data.fetch("price_cents"))
  )
end
```

## RSpec: explicit examples, no loops

Don't generate examples by looping over a table of inputs and expected values. Write each `it`
block out. Loops make specs harder to read.

If there are 5 or more examples with the same shape, suggest shared examples (`it_behaves_like`)
to the user instead of applying them unasked.

Bad: examples generated from a hash:

```ruby
describe "#discount" do
  {
    2 => 0,
    3 => 150,
    5 => 250
  }.each do |quantity, cents|
    it "is #{Money.from_cents(cents).format} for #{quantity} item(s)" do
      expect(promo.discount(strawberries, quantity)).to eq(Money.from_cents(cents, "USD"))
    end
  end
end
```

Good: each example written out:

```ruby
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
end
```
