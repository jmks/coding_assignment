require_relative "../lib/price_estimator"

describe PriceEstimator do
  describe "#estimate" do
    let(:subject) { described_class.new }

    it "estimates $1,591.58 for job $1,299.99, 3 people, food" do
      expect(subject.estimate("$1,299.99, 3 people, food")).to eq "$1,591.58"
    end

    it "estimates $6,199.81 for job $5,432.00, 1 person, drugs" do
      expect(subject.estimate("$5,432.00, 1 person, drugs")).to eq "$6,199.81"
    end
  end
end
