class FortuneTellingsController < ApplicationController
  def new
    @messages = []
  end

  def create
    Rails.logger.info "Fortune telling request: #{params[:message]}"

    @user_message = params[:message]
    @bot_response = generate_dummy_response

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def generate_dummy_response
    responses = [
      {
        service: "AWS Lambda",
        reason: "今日のあなたには、サーバーレスで軽快な Lambda がぴったり！",
        article: "https://aws.amazon.com/jp/blogs/news/example-lambda-article/"
      },
      {
        service: "Amazon S3",
        reason: "安定感のある S3 があなたの気分にマッチします。",
        article: "https://aws.amazon.com/jp/blogs/news/example-s3-article/"
      },
      {
        service: "Amazon DynamoDB",
        reason: "スピード重視の DynamoDB で今日を乗り切りましょう！",
        article: "https://aws.amazon.com/jp/blogs/news/example-dynamodb-article/"
      }
    ]

    responses.sample
  end
end
