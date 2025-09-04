class AwsService < ApplicationRecord
  validate :name, presence: true, uniqueness: true
  validate :description, presence: true
end
