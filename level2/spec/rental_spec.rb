# frozen_string_literal: true

require 'date'

require_relative '../../spec/spec_helper'
require_relative '../lib/rental'

RSpec.describe Rental do
  context 'when correct input' do
    let(:rental) do
      described_class.new(id: 1, car_id: 1, start_date: '2017-12-8', end_date: '2017-12-10', distance: 100)
    end

    it { expect { rental }.not_to raise_error }
  end

  context 'when incorrect input' do
    let(:invalid_rental) do
      described_class.new(id: '1', car_id: '1', start_date: Date.today, end_date: Date.today + 1, distance: '100')
    end

    let(:invalid_rental_dates) do
      described_class.new(id: 1, car_id: 1, start_date: '2017-01-02', end_date: '2017-01-01', distance: 100)
    end

    it { expect { invalid_rental_dates }.to raise_error(ArgumentError) }
  end
end
