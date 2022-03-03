# frozen_string_literal: true

require 'date'

# Represents booking request from 'drivers'
class Rental
  attr_reader :id, :car_id, :start_date, :end_date, :distance

  def initialize(id:, car_id:, start_date:, end_date:, distance:)
    @id = id
    @car_id = car_id
    @start_date = string_to_date start_date
    @end_date = string_to_date end_date
    @distance = distance

    validate_input_types
    validate_timeline
  end

  def duration
    (start_date - end_date).to_i.abs + 1
  end

  private

  def validate_input_types
    raise ArgumentError, 'id must be an Integer' unless id.is_a? Integer
    raise ArgumentError, 'car_id must be an Integer' unless car_id.is_a? Integer
    raise ArgumentError, 'distance must be an Integer' unless distance.is_a? Integer
  end

  def validate_timeline
    raise ArgumentError, 'end_date must be > than start_date' if end_date < start_date
  end

  def string_to_date(string)
    DateTime.strptime(string, '%Y-%m-%d')
  end
end
