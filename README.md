# LangChain Fortune Teller

LangChain Rubyを活用したデモンストレーションアプリケーション。ユーザーの気分に応じてAWSサービスをレコメンドする「占い師」機能と、技術的な相談に答える「コンサルタント」機能を提供します。

## 主な機能

### AWS Service Fortune Teller（占い師機能）
- ユーザーの今の気分や感情を理解し、ぴったりのAWSサービスを提案
- 選んだサービスがどのように役立つか、優しく説明
- 関連する技術記事やドキュメントへのリンクを提供

### AWS Consultant（技術相談機能）
- AWSソリューションアーキテクトとして技術的な質問に回答
- 適切なAWSサービスやアーキテクチャパターンを提案
- コスト、パフォーマンス、セキュリティ、スケーラビリティを考慮したアドバイス

## LangChain機能の活用例

このアプリケーションでは、LangChain Rubyの様々な機能を実装例として活用しています：

### Assistant API の活用
- **構造化出力（StructuredOutputParser）**
  - JSONスキーマを定義して、LLMからの出力を構造化
  - `app/models/fortune_teller.rb`で実装
- **カスタムツールの実装**
  - `Tools::AwsServiceTool`：AWSサービスをランダムに選択するカスタムツール
- **外部ツールの統合**
  - `Langchain::Tool::GoogleSearch`：関連記事を検索して提供

### LLM Chat API の活用
- **コンテキスト管理を含む対話実装**
  - 会話履歴を保持し、文脈を理解した応答を生成
  - `app/models/aws_consultant.rb`で実装
- **Temperature設定によるレスポンス調整**
  - 創造的で自然な対話を実現

## アーキテクチャ

### 技術スタック
- **フレームワーク**: Ruby on Rails 8.0.2
- **データベース**: PostgreSQL
- **主要Gem**:
  - `langchainrb`: LangChainのRuby実装
  - `ruby-openai`: OpenAI APIクライアント
  - `google_search_results`: Google検索API統合

### アプリケーション構成
```
app/
├── models/
│   ├── fortune_teller.rb      # 占い師機能のメインロジック
│   ├── aws_consultant.rb      # コンサルタント機能のメインロジック
│   ├── aws_service.rb        # AWSサービスのマスターデータ
│   ├── tools/
│   │   └── aws_service_tool.rb # カスタムツールの実装
│   └── chat_session.rb       # チャットセッション管理
├── controllers/
│   ├── fortune_tellings_controller.rb
│   ├── chat_sessions_controller.rb
│   └── messages_controller.rb
└── views/
    └── (HAMLテンプレート)
```

## デプロイ構成

### インフラストラクチャ
- **ホスティング**: [Fly.io](https://fly.io)
- **コンテナ**: Dockerによるコンテナ化

### CI/CD パイプライン
GitHub Actionsを使用した自動デプロイ：

1. **トリガー**: mainブランチへのプッシュ
2. **ワークフロー**: `.github/workflows/fly-deploy.yml`
3. **プロセス**:
   - コードのチェックアウト
   - Fly.ioへの自動デプロイ
   - 並行実行制御（concurrency group）

```yaml
name: Fly Deploy
on:
  push:
    branches:
      - main
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: superfly/flyctl-actions/setup-flyctl@master
      - run: flyctl deploy --remote-only
```

## セットアップ

### 必要な環境変数
```bash
OPENAI_KEY=your_openai_api_key
GOOGLE_SEARCH_KEY=your_google_search_api_key
```

### ローカル開発環境の構築

1. リポジトリのクローン
```bash
git clone https://github.com/yamat47/langchain-fortune-teller.git
cd langchain-fortune-teller
```

2. 依存関係のインストール
```bash
bundle install
```

3. データベースのセットアップ
```bash
rails db:create
rails db:migrate
rails db:seed_do
```

4. 環境変数の設定
```bash
cp .env.example .env
# .envファイルに必要なAPIキーを設定
```

5. サーバーの起動
```bash
rails server
```

## 開発

### テストの実行
```bash
bundle exec rspec
```

### コード規約
RuboCopを使用してコードスタイルを統一しています：

```bash
bundle exec rubocop
bundle exec rubocop -a  # 自動修正
```

### Dev Container
VS CodeのDev Container環境を用意しています。`.devcontainer/`ディレクトリに設定があり、コンテナ内で開発環境を構築できます。
