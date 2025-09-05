# frozen_string_literal: true

class ChatSession < ApplicationRecord
  has_many :messages, dependent: :destroy

  before_create :generate_uuid

  def to_param
    uuid
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end