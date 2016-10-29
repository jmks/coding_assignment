class PriceEstimator
  def estimate(repack_description)
    repacking = Repacking.new(repack_description)
    calc      = MarkupCalculator.new(repacking)
    format_cents_as_currency(calc.final_markup)
  end

  private

  def format_cents_as_currency(price_cents)
    dollars = price_cents / 100
    cents   = price_cents % 100

    "$#{thousands_delimited dollars}.#{cents.to_s.rjust(2, '0')}"
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
    attr_reader :base_price_cents, :categories

    def initialize(description)
      @base_price_cents = extract_base_price_cents(description)
      @categories = extract_categories(description)
    end

    private

    def extract_base_price_cents(description)
      description
        .split(", ")
        .first
        .sub(/^\$/, "")
        .sub(/,/, "")
        .sub(/\./, "")
        .to_i
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
      "people"      => 0.012,
      "drugs"       => 0.075,
      "food"        => 0.13,
      "electronics" => 0.075,
    }.freeze

    def initialize(job)
      @job = job
    end

    def final_markup
      flat_markup + category_markup
    end

    private

    attr_reader :job

    def flat_markup
      (job.base_price_cents * 1.05).round
    end

    def category_markup
      (category_markup_percent * flat_markup).round
    end

    def category_markup_percent
      job.categories.reduce(0.0) do |markup, category_quantity|
        category, quantity = *category_quantity
        markup + quantity * markup_for(category)
      end
    end

    def markup_for(category)
      normalized_category = category == "person" ? "people" : category
      CATEGORY_MARKUPS.fetch(normalized_category, 0.0)
    end
  end
end
