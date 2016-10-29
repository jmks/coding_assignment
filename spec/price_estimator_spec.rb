require_relative "../lib/price_estimator"

describe PriceEstimator do
  describe "#estimate" do
    let(:subject) { described_class.new }

    xit "estimates $1,591.58 for job $1,299.99, 3 people, food" do
      expect(subject.estimate("$1,299.99, 3 people, food")).to eq "$1,591.58"
    end

    xit "estimates $6,199.81 for job $5,432.00, 1 person, drugs" do
      expect(subject.estimate("$5,432.00, 1 person, drugs")).to eq "$6,199.81"
    end

    context "without categories" do
      it "returns the flat markup price of $105.00 on job $100.00" do
        expect(subject.estimate("$100.00")).to eq "$105.00"
      end
    end
  end
end

describe PriceEstimator::JobParser do
  describe "#base_price_cents" do
    it "returns 1_299_99 for job $1,299.99, 3 people, food" do
      job = described_class.new("$1,299.99, 3 people, food")
      expect(job.base_price_cents).to be 1_299_99
    end

    it "returns 12_456_95 for job $12,456.95" do
      job = described_class.new("$12,456.95")
      expect(job.base_price_cents).to be 12_456_95
    end
  end

  describe PriceEstimator::MarkupCalculator do
    describe "#final_markup" do
      context "with no categories" do
        let(:job) { double(base_price_cents: 1_00, categories: []) }
        let(:subject) { described_class.new(job) }

        it "returns the flat markup of 105 on 100" do
          expect(subject.final_markup).to eql 1_05
        end
      end

      context "with categories" do
        it "returns $1,062.60 for a $1,000.00 job with 1 person" do
          job  = double(base_price_cents: 1_000_00, categories: [["person", 1]])
          calc = described_class.new(job)

          expect(calc.final_markup).to eq 1_062_60
        end
      end
    end
  end
end
