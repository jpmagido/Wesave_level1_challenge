# frozen_string_literal: true

require_relative 'car'
require_relative 'rental'

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
    array = rentals.inject([]) do |acc, rental|
      acc << { id: rental.id, price: compute_rental_price(rental.id) }
    end

    { rentals: array }
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
      validate_id(:rentals, rental[:id])
      find_car(rental[:car_id])
      rentals << create_rental(rental)
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

  def compute_rental_price(rental_id)
    my_rental = find_rental(rental_id)
    associated_car = find_car(my_rental.car_id)

    duration_price = my_rental.duration * associated_car.price_per_day
    distance_price = my_rental.distance * associated_car.price_per_km
    duration_price + distance_price
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

  class RecordInvalid < StandardError; end

  class RecordNotFound < StandardError; end
end
