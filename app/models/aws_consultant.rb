# frozen_string_literal: true

class AwsConsultant
  include ActiveModel::Model
  include ActiveModel::Attributes

  PROMPT = <<~PROMPT
    あなたはAWSソリューションアーキテクトとして、技術的な相談に乗るプロフェッショナルです。
    ユーザーの質問や課題に対して、適切なAWSサービスやアーキテクチャパターンを提案し、
    実装方法やベストプラクティスについてアドバイスしてください。

    対話のポイント:
    - ユーザーの技術的な課題を深く理解する
    - 適切なAWSサービスやパターンを提案する
    - コストとパフォーマンスのバランスを考慮する
    - セキュリティやスケーラビリティの観点も含める
    - 具体的な実装方法や考慮事項を説明する

    通常の対話として自然に答えてください。
    技術的な内容は正確に、でも分かりやすく説明してください。
  PROMPT

  def chat(message, context = [])
    llm = Langchain::LLM::OpenAI.new(
      api_key: ENV.fetch('OPENAI_KEY', nil),
      default_options: { temperature: 0.7 }
    )

    messages = build_messages(context, message)
    
    response = llm.chat(messages: messages)
    response.chat_completion
  end

  private

  def build_messages(context, message)
    messages = [
      { role: 'system', content: PROMPT }
    ]
    
    context.each do |msg|
      role = msg[:role] == 'user' ? 'user' : 'assistant'
      messages << { role: role, content: msg[:content] }
    end
    
    messages << { role: 'user', content: message }
    messages
  end
end