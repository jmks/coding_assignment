require_relative "../lib/price_estimator"

describe PriceEstimator do
  describe "#estimate" do
    context "without categories" do
      it "returns the flat markup price of $105.00 on job $100.00" do
        estimator = described_class.new("$100.00")
        expect(estimator.estimate).to eq "$105.00"
      end
    end

    it "estimates $1,591.58 for job $1,299.99, 3 people, food" do
      estimator = described_class.new("$1,299.99, 3 people, food")
      expect(estimator.estimate).to eq "$1,591.58"
    end

    it "estimates $6,199.81 for job $5,432.00, 1 person, drugs" do
      estimator = described_class.new("$5,432.00, 1 person, drugs")
      expect(estimator.estimate).to eq "$6,199.81"
    end

    it "estimates $13,707.63 for job $12,456.95, 4 people, books" do
      estimator = described_class.new("$12,456.95, 4 people, books")
      expect(estimator.estimate).to eq "$13,707.63"
    end
  end
end

describe PriceEstimator::Repacking do
  describe "#base_price" do
    it "returns 1299.99 for job $1,299.99, 3 people, food" do
      repacking = described_class.new("$1,299.99, 3 people, food")
      expect(repacking.base_price).to eq BigDecimal("1299.99")
    end

    it "returns 12,456.95 for job $12,456.95" do
      repacking = described_class.new("$12,456.95")
      expect(repacking.base_price).to eq BigDecimal("12456.95")
    end
  end

  describe "#categories" do
    context "with no categories" do
      let(:description) { "$1,000.00" }

      it "is empty" do
        repacking = described_class.new(description)
        expect(repacking.categories).to be_empty
      end
    end

    it "returns [['drugs', 3]] for job $100.00, 3 drugs" do
      repacking = described_class.new("$100.00, 3 drugs")
      expect(repacking.categories).to match_array [["drugs", 3]]
    end

    it "returns [['person', 1]] for job $1,701.33, person" do
      repacking = described_class.new("$1,701.33, person")
      expect(repacking.categories).to match_array [["person", 1]]
    end

    it "returns [['drugs', 3], ['electronics', 2]] for job $19,433.77, 3 drugs, 2 electronics" do
      repacking = described_class.new("$19,433.77, 3 drugs, 2 electronics")
      expect(repacking.categories).to match_array [["drugs", 3], ["electronics", 2]]
    end
  end

  describe PriceEstimator::MarkupCalculator do
    describe "#final_price" do
      context "with no categories" do
        let(:repacking) do
          double(base_price: BigDecimal.new(1), categories: [])
        end
        let(:subject) { described_class.new(repacking) }

        it "returns the flat markup of 1.05 on 1.00" do
          expect(subject.final_price).to eql BigDecimal.new('1.05')
        end
      end

      context "with categories" do
        it "returns 1,062.60 for a 1,000.00 job with 1 person" do
          repacking =
            double(
              base_price: BigDecimal.new(1_000),
              categories: [["person", 1]]
            )
          calc = described_class.new(repacking)

          expect(calc.final_price).to eq BigDecimal.new('1062.60')
        end

        it "returns 1,153.95 for a 1,000.00 job with 2 people and 1 drugs" do
          repacking =
            double(
              base_price: BigDecimal.new(1_000),
              categories: [["people", 2], ["drugs", 1]]
            )
          calc = described_class.new(repacking)

          expect(calc.final_price).to eq BigDecimal.new('1153.95')
        end

        it "returns 13,305.60 for a 9,900.00 job with 1 electronics and 2 food" do
          repacking =
            double(
              base_price: BigDecimal.new(9_900),
              categories: [["electronics", 1], ["food", 2]]
            )
          calc = described_class.new(repacking)

          expect(calc.final_price).to eq BigDecimal.new('13305.60')
        end
      end
    end
  end
end
