# frozen_string_literal: true

class FortuneTeller
  include ActiveModel::Model
  include ActiveModel::Attributes

  def chat(message)
    responses = [
      {
        service: 'AWS Lambda',
        reason: '今日のあなたには、サーバーレスで軽快な Lambda がぴったり！',
        article: 'https://aws.amazon.com/jp/blogs/news/example-lambda-article/'
      },
      {
        service: 'Amazon S3',
        reason: '安定感のある S3 があなたの気分にマッチします。',
        article: 'https://aws.amazon.com/jp/blogs/news/example-s3-article/'
      },
      {
        service: 'Amazon DynamoDB',
        reason: 'スピード重視の DynamoDB で今日を乗り切りましょう！',
        article: 'https://aws.amazon.com/jp/blogs/news/example-dynamodb-article/'
      }
    ]

    responses.sample
  end
end
