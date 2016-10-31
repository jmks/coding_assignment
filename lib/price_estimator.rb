require "bigdecimal"

class PriceEstimator
  def initialize(repack_description)
    @description = repack_description
  end

  def estimate
    currency_format(calculator.final_price)
  end

  private

  def calculator
    MarkupCalculator.new(Repacking.new(@description))
  end

  def currency_format(big_decimal)
    cents = (big_decimal.frac * 100).to_i
    "$#{thousands_delimited(big_decimal.to_i)}.#{cents.to_s.rjust(2, '0')}"
  end

  def thousands_delimited(dollars)
    dollars
      .to_s
      .reverse
      .chars
      .each_slice(3)
      .map(&:join)
      .join(",")
      .reverse
  end

  class Repacking
    attr_reader :base_price, :categories

    def initialize(description)
      @base_price = extract_base_price(description)
      @categories = extract_categories(description)
    end

    private

    def extract_base_price(description)
      unformatted_price =
        description
          .split(", ")
          .first
          .sub(/^\$/, "")
          .gsub(",", "")

      BigDecimal(unformatted_price)
    end

    def extract_categories(description)
      description
        .split(", ")
        .slice(1..-1)
        .map do |cat_desc|
          quantity = cat_desc.to_i
          quantity = 1 if quantity.zero?
          category = cat_desc.sub(/^\d*\s*/, '')

          [category, quantity]
        end
    end
  end

  class MarkupCalculator
    CATEGORY_MARKUPS = {
      "people"      => BigDecimal("0.012"),
      "drugs"       => BigDecimal("0.075"),
      "food"        => BigDecimal("0.13"),
      "electronics" => BigDecimal("0.02")
    }.freeze

    def initialize(repacking)
      @repacking = repacking
    end

    def final_price
      flat_markup + category_markup
    end

    private

    attr_reader :repacking

    def flat_markup
      (repacking.base_price * BigDecimal("1.05")).round(2)
    end

    def category_markup
      (category_markup_percent * flat_markup).round(2)
    end

    def category_markup_percent
      repacking.categories.reduce(BigDecimal(0)) do |markup, category_quantity|
        category, quantity = *category_quantity
        markup + quantity * markup_for(category)
      end
    end

    def markup_for(category)
      normalized_category = category == "person" ? "people" : category
      CATEGORY_MARKUPS.fetch(normalized_category, BigDecimal(0))
    end
  end
end
