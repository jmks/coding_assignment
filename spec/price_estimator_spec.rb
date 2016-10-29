require_relative "../lib/price_estimator"

describe PriceEstimator do
  describe "#estimate" do
    let(:subject) { described_class.new }

    it "estimates $1,591.58 for job $1,299.99, 3 people, food" do
      expect(subject.estimate("$1,299.99, 3 people, food")).to eq "$1,591.58"
    end
  end
end
