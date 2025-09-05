# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :chat_session
  delegated_type :messageable, types: %w[UserMessage FortuneResultMessage SystemMessage]

  validates :chat_session, presence: true
  validates :messageable, presence: true

  scope :ordered, -> { order(:created_at) }
end