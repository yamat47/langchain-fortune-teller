# frozen_string_literal: true

class SystemMessage < ApplicationRecord
  has_one :message, as: :messageable, touch: true

  validates :content, presence: true
end