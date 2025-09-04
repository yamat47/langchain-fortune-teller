# frozen_string_literal: true

class AwsService < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
