# frozen_string_literal: true

class FortuneTellingsController < ApplicationController
  def new
    @messages = []
  end

  def create
    Rails.logger.info "Fortune telling request: #{params[:message]}"

    # Create new chat session
    chat_session = ChatSession.create!

    # Save user message
    user_message = UserMessage.create!(content: params[:message])
    chat_session.messages.create!(messageable: user_message)

    # Get fortune telling result
    fortune_teller = FortuneTeller.new
    chat_reply = fortune_teller.chat(params[:message])

    # Save fortune result message
    fortune_result = FortuneResultMessage.create!(
      service_name: chat_reply['service_name'],
      service_description: chat_reply['service_description'],
      reason: chat_reply['reason'],
      reference_url: chat_reply['reference_url']
    )
    chat_session.messages.create!(messageable: fortune_result)

    # Redirect to chat session
    redirect_to chat_session_path(chat_session.uuid)
  end
end
