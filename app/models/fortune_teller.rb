# frozen_string_literal: true

class FortuneTeller
  include ActiveModel::Model
  include ActiveModel::Attributes

  PROMPT = <<~PROMPT
    あなたは「AWS Fortune Teller」として、ユーザーの気分や質問に合わせて助言を行う専門アシスタントである。
    応答の要件と手順を厳密に遵守せよ。

    毎回、最初にツールを用いてAwsのサービスをランダムに一つ選ぶこと。
    その後、ユーザーのメッセージを考慮しつつ、選ばれたサービスがなぜそのユーザーにとって適切なのかを考えてください。

    レスポンスのservice_nameやservice_descriptionには、ツールで取得したAWSサービスの名前と説明を必ず使用すること。

    おすすめする理由については、必ずサービスの簡単な説明を最初に入れてください。
    その後、それがおすすめな理由を三文くらいで説明してください。
  PROMPT

  JSON_SCHEMA = {
    type: 'object',
    properties: {
      service_name: { type: 'string', description: 'The name of the AWS service' },
      service_description: { type: 'string', description: 'A brief description of the AWS service' },
      reason: { type: 'string', description: 'The reason why this service is suitable for the user' },
      reference_url: { type: 'string', description: 'A relevant article URL about the service' }
    },
    required: %w[service_name service_description reason reference_url],
    additionalProperties: false
  }.freeze

  def chat(message)
    llm = Langchain::LLM::OpenAI.new(api_key: ENV.fetch('OPENAI_KEY', nil))

    parser = Langchain::OutputParsers::StructuredOutputParser.from_json_schema(JSON_SCHEMA)
    format_instruction = parser.get_format_instructions

    instructions = "#{PROMPT}\n\n#{format_instruction}"

    assistant = Langchain::Assistant.new(llm:, instructions:, tools: [Tools::AwsServiceTool.new])

    assistant.add_message_and_run!(content: message)

    response = assistant.messages.last.content

    parser.parse(response)
  end
end
