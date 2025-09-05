# frozen_string_literal: true

class FortuneTeller
  include ActiveModel::Model
  include ActiveModel::Attributes

  PROMPT = <<~PROMPT
    あなたは優しくて親身なAWSサービスアドバイザーです。
    ユーザーの今の気分や感情に寄り添いながら、ぴったりのAWSサービスを見つけてあげましょう。

    まず、ツールを使ってAWSサービスを1つ選んでください。
    そして、ユーザーの今の気持ちや状況をよく理解して、
    そのサービスがどんな風に役立つか、優しく説明してあげてください。

    説明のポイント:
    - まず、サービスがどんなものか簡単に紹介
    - ユーザーの今の気分とサービスの素敵な繋がりを見つけて伝える
    - 「こんな風に使えるよ」「きっとこんないいことがあるよ」という感じで、
      前向きで温かいメッセージを添える

    その後、参考になる記事のURLを1つ紹介してください。
    サービスに関する説明をするようなドキュメントが望ましいです。
    AWSの公式ブログや、信頼できる技術系メディアの記事を選んでください。
    Google検索ツールを使って、必ず最新の情報を取得してください、捏造は厳禁です。

    - 検索クエリは「<サービス正式名> とは」「<サービス正式名> documents」等を組み合わせ、日本語/英語を併用。
    - 結果から **妥当で具体性のある導入事例**（企業名・プロダクト・技術解説記事・アーキ記事・AWS 公式事例など）を抽出。
    - 低品質アフィリエイトや転載寄せ集めは避ける。重複や内容が乏しいものは除外。
    - 見つけたページはcurlなどで実際にアクセスし、内容を確認すること。

    ユーザーの気持ちに共感しながら、「一緒に良い方向に向かっていきましょう」
    という気持ちで接してください。
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

    assistant = Langchain::Assistant.new(
      llm:, instructions:,
      tools: [
        Tools::AwsServiceTool.new,
        Langchain::Tool::GoogleSearch.new(api_key: ENV.fetch('GOOGLE_SEARCH_KEY', nil))
      ]
    )

    assistant.add_message_callback = lambda do |message|
      puts "Assistant: #{message.content}"
    end

    assistant.add_message_and_run!(content: message)

    response = assistant.messages.last.content

    parser.parse(response)
  end
end
