# frozen_string_literal: true

# Represent pricing computing in our Rental Business
class Price
  attr_reader :rental, :car

  def initialize(rental, car)
    @rental = rental
    @car = car
  end

  def compute
    duration_price + distance_price
  end

  private

  def distance_price
    rental.distance * car.price_per_km
  end

  def duration_price
    (0...rental.duration).to_a.inject(0) do |acc, day|
      acc + car.price_per_day * discount(day)
    end.to_i
  end

  def discount(day)
    return 1 if day.zero?
    return 0.9 if day < 4
    return 0.7 if day < 10

    0.5
  end
end
