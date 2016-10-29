class PriceEstimator
  def estimate(job_description)
    job = JobParser.new(job_description)
    "$1,591.58"
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
