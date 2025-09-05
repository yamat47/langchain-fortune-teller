# frozen_string_literal: true

class FortuneTellingsController < ApplicationController
  def new
    @messages = []
  end

  def create
    Rails.logger.info "Fortune telling request: #{params[:message]}"

    @user_message = params[:message]

    fortune_teller = FortuneTeller.new
    @bot_response = fortune_teller.chat(@user_message)

    respond_to do |format|
      format.turbo_stream
    end
  end
end
