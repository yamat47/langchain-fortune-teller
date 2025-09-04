# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_chat_session

  def create
    @user_message_content = params[:message]

    # Save user message
    user_message = UserMessage.create!(content: @user_message_content)
    @user_message_record = @chat_session.messages.create!(messageable: user_message)

    # Use AWS consultant for normal conversation
    consultant = AwsConsultant.new
    
    # Build context from previous messages
    context = build_conversation_context
    
    # Get consultant response
    consultant_reply = consultant.chat(@user_message_content, context)
    
    # Save system message
    system_message = SystemMessage.create!(content: consultant_reply)
    @system_message_record = @chat_session.messages.create!(messageable: system_message)

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_chat_session
    @chat_session = ChatSession.find_by!(uuid: params[:chat_session_uuid])
  end
  
  def build_conversation_context
    context = []
    @chat_session.messages.ordered.each do |message|
      if message.messageable_type == 'UserMessage'
        context << { role: 'user', content: message.messageable.content }
      elsif message.messageable_type == 'SystemMessage'
        context << { role: 'assistant', content: message.messageable.content }
      elsif message.messageable_type == 'FortuneResultMessage'
        # Convert fortune result to text format for context
        fortune = message.messageable
        content = "#{fortune.service_name}: #{fortune.service_description}\n#{fortune.reason}"
        context << { role: 'assistant', content: content }
      end
    end
    context
  end
end