# Currency helper provides helper methods for working with currency-like values
module CurrencyHelper
  # formats a big decimal as currency.
  #    1 =>     $1.00
  # 1000 => $1,000.00
  def format_bigdecimal(big_decimal)
    cents = (big_decimal.frac * 100).to_i
    "$#{thousands_delimited(big_decimal.to_i)}.#{cents.to_s.rjust(2, '0')}"
  end

  private

  def thousands_delimited(dollars)
    dollars.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end
end
