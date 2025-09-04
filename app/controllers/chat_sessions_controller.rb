# frozen_string_literal: true

class ChatSessionsController < ApplicationController
  before_action :set_chat_session

  def show
    @messages = @chat_session.messages.ordered
  end

  def create_message
    @user_message_content = params[:message]

    # Save user message
    user_message = UserMessage.create!(content: @user_message_content)
    @user_message_record = @chat_session.messages.create!(messageable: user_message)

    # Generate AI response with fortune teller
    fortune_teller = FortuneTeller.new
    fortune_result = fortune_teller.chat(@user_message_content)
    
    # Save fortune result message
    fortune_message = FortuneResultMessage.create!(
      service_name: fortune_result['service_name'],
      service_description: fortune_result['service_description'],
      reason: fortune_result['reason'],
      reference_url: fortune_result['reference_url']
    )
    @system_message_record = @chat_session.messages.create!(messageable: fortune_message)

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_chat_session
    @chat_session = ChatSession.find_by!(uuid: params[:uuid])
  end
end