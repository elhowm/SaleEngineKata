# Sale engine kata

## Usage

1. Requires Ruby 4.0.9 installed. (`mise install` if you use mise).

2. Install the gems

```bash
bundle install
```

3. Run the app and enter product codes separated by spaces

```text
$ ruby app.rb
Enter product codes separated by spaces (e.g. FR SR CF):
FR SR FR FR CF
Positions:
- Fruit Tea x3 | $9.33 - $3.11 (promo)
- Strawberries x1 | $5.00
- Coffee x1 | $11.23
Promos applied:
- Fruit Tea: buy one, get one free.
Total: $22.45
```

Unknown codes are skipped. Product codes and prices are in `config/products.json`.

Run the specs:

```bash
bundle exec rspec
```

## Design/Architecture - Discounts

A grocery store sells the following products:
• Fruit Tea (FR) - $3.11
• Strawberries (SR) - $5.00
• Coffee (CF) - $11.23
• Apple Juice (AJ) - $7.25
​
The marketing team is pushing hard to come up with new offers. So far, we have the following
rules:
-​ Fruit Tea: buy one, get one free.
-​ Strawberries: if you buy 3 or more, the price of each drops to $4.50.

These rules are independent of each other, and both can apply to the same checkout.
We expect the marketing team to keep coming up with new ideas for boosting sales.
Please implement a checkout system that meets the requirements above, can be extended with new rules, and provides an interface similar to the following:

```ruby
co = Checkout.new(promo1, promo2, ...)
co.scan('FR')
co.scan('CF')
...
total_cost = co.total
```

## IO examples

Interactive interface that allows to validate current offers is nice to have.

Each position shows its full price; when promos apply, their summed discount follows as `- $N (promo)`.
Positions are grouped by product code in order of first appearance in the cart.

### A

#### Input

```text
FR SR FR FR CF
```

#### Output

```text
Positions:
- Fruit Tea x3 | $9.33 - $3.11 (promo)
- Strawberries x1 | $5.00
- Coffee x1 | $11.23
Promos applied:
- Fruit Tea: buy one, get one free.
Total: $22.45
```

### B

#### Input

```text
FR FR
```

#### Output

```text
Positions:
- Fruit Tea x2 | $6.22 - $3.11 (promo)
Promos applied:
- Fruit Tea: buy one, get one free.
Total: $3.11
```

### C

#### Input

```text
SR SR FR SR
```

#### Output

```text
Positions:
- Strawberries x3 | $15.00 - $1.50 (promo)
- Fruit Tea x1 | $3.11
Promos applied:
- Strawberries x3 or more for $4.50.
Total: $16.61
```

### D

#### Input

```text
SR SR FR FR SR CF
```

#### Output

```text
Positions:
- Strawberries x3 | $15.00 - $1.50 (promo)
- Fruit Tea x2 | $6.22 - $3.11 (promo)
- Coffee x1 | $11.23
Promos applied:
- Strawberries x3 or more for $4.50.
- Fruit Tea: buy one, get one free.
Total: $27.84
```
