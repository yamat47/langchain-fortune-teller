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

    # Generate AI response
    fortune_teller = FortuneTeller.new
    chat_reply = fortune_teller.chat(@user_message_content)

    # Save system message
    system_message = SystemMessage.create!(content: chat_reply)
    @system_message_record = @chat_session.messages.create!(messageable: system_message)

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_chat_session
    @chat_session = ChatSession.find_by!(uuid: params[:uuid])
  end
end