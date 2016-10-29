class PriceEstimator
  def estimate(job_description)
    job = JobParser.new(job_description)
    cost = (job.base_price_cents * 1.05).round
    format_cents_as_currency(cost)
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
end
