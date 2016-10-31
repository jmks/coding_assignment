require_relative "../lib/currency_helper"

describe CurrencyHelper do
  let(:included_class) { Class.new { include(CurrencyHelper) } }
  let(:subject) { included_class.new }

  describe "#format_bigdecimal" do
    it "returns $123.45 for 123.45" do
      expect(subject.format_bigdecimal(BigDecimal("123.45"))).to eq "$123.45"
    end

    context "with trailing zeros" do
      it "returns $100.00 for 100" do
        expect(subject.format_bigdecimal(BigDecimal(100))).to eq "$100.00"
      end
    end

    context "with multiple thousands" do
      it "returns $12,345,678.90 for 12345678.90" do
        amount = BigDecimal("12345678.90")
        expect(subject.format_bigdecimal(amount)).to eq "$12,345,678.90"
      end
    end
  end
end
