# frozen_string_literal: true

require_relative '../../spec/spec_helper'
require_relative '../lib/commission'
require_relative '../lib/rental'
require_relative '../lib/car'

RSpec.describe Commission do
  subject(:commission) { described_class.new(rental, 12_800 * 0.3) }

  let(:rental) { Rental.new(id: 1, car_id: 1, start_date: '2022-02-01', end_date: '2022-02-03', distance: 1_000) }
  let(:car) { Car.new(id: 1, price_per_day: 1_000, price_per_km: 10) }

  it 'initializes properly' do
    expect { commission }.not_to raise_error
  end

  it '#compute' do
    expect(commission.compute[:insurance_fee]).to eq 576
    expect(commission.compute[:assistance_fee]).to eq 300
    expect(commission.compute[:drivy_fee]).to eq 276
  end
end
