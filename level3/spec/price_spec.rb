# frozen_string_literal: true

require_relative '../../spec/spec_helper'
require_relative '../lib/price'

RSpec.describe Price do
  subject(:pricing) { described_class.new(rental, car) }

  let(:rental) { Rental.new(id: 1, car_id: 1, start_date: '2022-02-01', end_date: '2022-02-03', distance: 1_000) }
  let(:car) { Car.new(id: 1, price_per_day: 1_000, price_per_km: 10) }

  it 'initializes properly' do
    expect { pricing }.not_to raise_error
  end

  it '#compute' do
    expect(pricing.compute).to eq 12_800
  end
end
