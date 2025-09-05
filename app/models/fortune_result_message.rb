# frozen_string_literal: true

class FortuneResultMessage < ApplicationRecord
  has_one :message, as: :messageable, touch: true

  validates :service_name, presence: true
  validates :service_description, presence: true
  validates :reason, presence: true
  validates :reference_url, presence: true
end