# frozen_string_literal: true

require_relative '../../spec/spec_helper'
require_relative '../lib/car'

RSpec.describe Car do
  context 'when proper input' do
    let(:car) { described_class.new(id: 1, price_per_day: 2000, price_per_km: 10) }

    it { expect { car }.not_to raise_error }
  end

  context 'when incorrect input' do
    let(:invalid_car) { described_class.new(id: '1', price_per_day: nil, price_per_km: true) }

    it { expect { invalid_car }.to raise_error(ArgumentError) }
  end
end
