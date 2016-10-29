require_relative "../lib/price_estimator"

describe PriceEstimator do
  describe "#estimate" do
    let(:subject) { described_class.new }

    it "estimates $1,591.58 for job $1,299.99, 3 people, food" do
      expect(subject.estimate("$1,299.99, 3 people, food")).to eq "$1,591.58"
    end

    xit "estimates $6,199.81 for job $5,432.00, 1 person, drugs" do
      expect(subject.estimate("$5,432.00, 1 person, drugs")).to eq "$6,199.81"
    end
  end
end

describe PriceEstimator::JobParser do
  describe "#base_price_cents" do
    it "returns 129_999 for job $1,299.99, 3 people, food" do
      job = described_class.new("$1,299.99, 3 people, food")
      expect(job.base_price_cents).to be 129_999
    end

    it "returns 1_245_695 for job $12,456.95" do
      job = described_class.new("$12,456.95")
      expect(job.base_price_cents).to be 1_245_695
    end
  end
end
