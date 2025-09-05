# frozen_string_literal: true

class FortuneTellingsController < ApplicationController
  def new
    @messages = []
  end

  def create
    Rails.logger.info "Fortune telling request: #{params[:message]}"

    @user_message = params[:message]

    fortune_teller = FortuneTeller.new
    chat_reply = fortune_teller.chat(@user_message)

    @service_name = chat_reply['service_name']
    @service_description = chat_reply['service_description']
    @reason = chat_reply['reason']
    @reference_url = chat_reply['reference_url']

    respond_to do |format|
      format.turbo_stream
    end
  end
end
