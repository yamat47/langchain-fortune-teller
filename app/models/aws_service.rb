# frozen_string_literal: true

class AwsService < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  class << self
    def random
      order('RANDOM()').first
    end
  end
end
