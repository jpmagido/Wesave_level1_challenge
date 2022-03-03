# frozen_string_literal: true

# Represent Commission split in our Rental Business
class Commission
  attr_reader :rental, :price

  def initialize(rental, price)
    @rental = rental
    @price = price * 0.3
  end

  def compute
    {
      insurance_fee: insurance_fee,
      assistance_fee: assistance_fee,
      drivy_fee: drivy_fee
    }
  end

  private

  def insurance_fee
    (price / 2).to_i
  end

  def assistance_fee
    rental.duration * 100
  end

  def drivy_fee
    (price - insurance_fee - assistance_fee).to_i
  end
end
