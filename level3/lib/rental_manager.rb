# frozen_string_literal: true

%w[car commission price rental].each { |file| require_relative file }

# Manages Car & Rental
class RentalManager
  attr_accessor :cars, :rentals
  attr_reader :input

  def initialize(input)
    @input = input
    @cars = []
    @rentals = []

    save_cars
    save_rentals
  end

  def rental_prices
    { rentals: pricing_array }
  end

  private

  def save_cars
    input[:cars].each do |car|
      validate_id(:cars, car[:id])
      cars << create_car(car)
    end
  end

  def save_rentals
    input[:rentals].each do |rental|
      new_rental = create_rental(rental)

      validate_id(:rentals, new_rental.id)
      validate_availability(new_rental)
      find_car(new_rental.car_id)
      rentals << new_rental
    end
  end

  def create_car(input)
    ::Car.new(id: input[:id], price_per_day: input[:price_per_day], price_per_km: input[:price_per_km])
  end

  def create_rental(input)
    ::Rental.new(
      id: input[:id],
      car_id: input[:car_id],
      start_date: input[:start_date],
      end_date: input[:end_date],
      distance: input[:distance]
    )
  end

  def pricing_array
    rentals.inject([]) do |acc, rental|
      acc.push(
        id: rental.id,
        price: compute_price(rental),
        commission: ::Commission.new(rental, compute_price(rental)).compute
      )
    end
  end

  def compute_price(rental)
    ::Price.new(rental, find_car(rental.car_id)).compute
  end

  def find_car(car_id)
    found_car = cars.detect { |car| car.id == car_id }
    raise RecordNotFound, "Cannot find Car with id = #{car_id}" unless found_car

    found_car
  end

  def find_rental(rental_id)
    found_rental = rentals.detect { |rental| rental.id == rental_id }
    raise RecordNotFound, "Cannot find Rental with id = #{rental_id}" unless found_rental

    found_rental
  end

  def validate_id(object_db, id)
    raise RecordInvalid, 'Id must be uniq' if send(object_db).any? { |object| object.id == id }
  end

  def validate_availability(new_rental)
    overlapping_rentals =
      rentals.select { |rental| rental.car_id == new_rental.car_id }
             .select { |rental| new_rental.start_date <= rental.end_date && new_rental.end_date >= rental.start_date }

    raise AvailabilityError, "New rental overlaps with: #{overlapping_rentals}" if overlapping_rentals.any?
  end

  class RecordInvalid < StandardError; end

  class RecordNotFound < StandardError; end

  class AvailabilityError < StandardError; end
end
