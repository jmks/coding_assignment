class PriceEstimator
  def estimate(job_description)
    job  = JobParser.new(job_description)
    calc = MarkupCalculator.new(job)
    format_cents_as_currency(calc.final_markup)
  end

  def format_cents_as_currency(price_cents)
    dollars = price_cents / 100
    cents   = price_cents % 100

    "$#{dollars}.#{cents.to_s.rjust(2, '0')}"
  end

  class JobParser

    attr_reader :base_price_cents

    def initialize(description)
      @base_price_cents = extract_base_price_cents(description)
    end

    def categories
      []
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
  end

  class MarkupCalculator
    CATEGORY_MARKUPS = {
      "person" => 0.012,
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
        markup + quantity * CATEGORY_MARKUPS.fetch(category, 0.0)
      end
    end
  end
end
