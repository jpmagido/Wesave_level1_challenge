# frozen_string_literal: true

require_relative '../../spec/spec_helper'
require_relative '../lib/rental_manager'

RSpec.describe RentalManager do
  subject(:rental_manager) { described_class.new(rental_manager_input) }

  let(:rental_manager_input) do
    {
      "cars": [
        { "id": 1, "price_per_day": 2_000, "price_per_km": 10 }
      ],
      "rentals": [
        { "id": 1, "car_id": 1, "start_date": '2015-12-8', "end_date": '2015-12-8', "distance": 100 },
        { "id": 2, "car_id": 1, "start_date": '2015-03-31', "end_date": '2015-04-01', "distance": 300 },
        { "id": 3, "car_id": 1, "start_date": '2015-07-3', "end_date": '2015-07-14', "distance": 1000 }
      ]
    }
  end

  describe '#rental_prices' do
    it 'returns proper format' do
      expect(rental_manager.rental_prices).to be_a Hash
      expect(rental_manager.rental_prices[:rentals]).to be_a Array
      expect(rental_manager.rental_prices[:rentals].first).to be_a Hash
    end

    it 'returns proper values' do
      expect(rental_manager.rental_prices[:rentals].first).to eq id: 1, price: 3_000
      expect(rental_manager.rental_prices[:rentals][1]).to eq id: 2, price: 6_800
      expect(rental_manager.rental_prices[:rentals].last).to eq id: 3, price: 27_800
    end
  end

  context 'when correct input' do
    let(:correct_input) do
      {
        'cars': [
          { "id": 1, "price_per_day": 2_000, "price_per_km": 10 },
          { "id": 2, "price_per_day": 2_000, "price_per_km": 10 }
        ],
        'rentals': [
          { "id": 1, "car_id": 1, "start_date": '2017-12-8', "end_date": '2017-12-10', "distance": 100 },
          { "id": 2, "car_id": 1, "start_date": '2017-12-11', "end_date": '2017-12-12', "distance": 100 }
        ]
      }
    end

    it { expect { described_class.new(correct_input) }.not_to raise_error }
  end

  context 'when incorrect input' do
    let(:incorrect_car_id) do
      {
        'cars': [
          { "id": 1, "price_per_day": 2_000, "price_per_km": 10 },
          { "id": 1, "price_per_day": 3_000, "price_per_km": 3 }
        ],
        'rentals': []
      }
    end

    let(:incorrect_rental_id) do
      {
        'cars': [
          { "id": 1, "price_per_day": 2_000, "price_per_km": 10 }
        ],
        'rentals': [
          { "id": 1, "car_id": 1, "start_date": '2017-12-8', "end_date": '2017-12-10', "distance": 100 },
          { "id": 1, "car_id": 1, "start_date": '2017-12-8', "end_date": '2017-12-10', "distance": 100 }
        ]
      }
    end

    let(:incorrect_rental_overlap) do
      {
        'cars': [
          { "id": 1, "price_per_day": 2_000, "price_per_km": 10 }
        ],
        'rentals': [
          { "id": 1, "car_id": 1, "start_date": '2017-12-8', "end_date": '2017-12-10', "distance": 100 },
          { "id": 2, "car_id": 1, "start_date": '2017-12-6', "end_date": '2017-12-12', "distance": 100 }
        ]
      }
    end

    let(:incorrect_car_association) do
      {
        'cars': [
          { "id": 1, "price_per_day": 2000, "price_per_km": 10 }
        ],
        'rentals': [
          { "id": 1, "car_id": 10, "start_date": '2017-12-8', "end_date": '2017-12-10', "distance": 100 }
        ]
      }
    end

    it 'raises if Car id NOT uniq' do
      expect { described_class.new(incorrect_car_id) }.to raise_error(RentalManager::RecordInvalid, 'Id must be uniq')
    end

    it 'raises if Rental id NOT uniq' do
      expect { described_class.new(incorrect_rental_id) }
        .to raise_error(RentalManager::RecordInvalid, 'Id must be uniq')
    end

    it 'raises if Car association not found' do
      expect { described_class.new(incorrect_car_association) }
        .to raise_error(RentalManager::RecordNotFound, 'Cannot find Car with id = 10')
    end

    it 'raises if Rental overlaps' do
      expect { described_class.new(incorrect_rental_overlap) }
        .to raise_error(RentalManager::AvailabilityError)
    end
  end
end
