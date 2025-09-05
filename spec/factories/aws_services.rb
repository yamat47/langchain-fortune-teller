# frozen_string_literal: true

FactoryBot.define do
  factory :aws_service do
    sequence(:name) { |n| "AWS Service #{n}" }
    description { 'A sample AWS service description' }
  end
end
