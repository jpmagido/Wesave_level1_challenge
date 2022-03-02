# frozen_string_literal: true

require_relative 'lib/rental_manager'

input = {
  "cars": [
    { "id": 1, "price_per_day": 2_000, "price_per_km": 10 },
    { "id": 2, "price_per_day": 3_000, "price_per_km": 15 },
    { "id": 3, "price_per_day": 1_700, "price_per_km": 8 }
  ],
  "rentals": [
    { "id": 1, "car_id": 1, "start_date": '2017-12-8', "end_date": '2017-12-10', "distance": 100 },
    { "id": 2, "car_id": 1, "start_date": '2017-12-14', "end_date": '2017-12-18', "distance": 550 },
    { "id": 3, "car_id": 2, "start_date": '2017-12-8', "end_date": '2017-12-10', "distance": 150 }
  ]
}

p RentalManager.new(input).rental_prices
