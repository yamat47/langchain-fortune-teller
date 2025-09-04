# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AwsService, type: :model do
  describe '.random' do
    context 'when no records exist' do
      it 'returns nil' do
        expect(described_class.random).to be_nil
      end
    end

    context 'when one record exists' do
      let!(:service) { create(:aws_service) }

      it 'returns the single record' do
        expect(described_class.random).to eq(service)
      end
    end

    context 'when multiple records exist' do
      let!(:service1) { create(:aws_service, name: 'EC2') }
      let!(:service2) { create(:aws_service, name: 'S3') }
      let!(:service3) { create(:aws_service, name: 'Lambda') }

      it 'returns one of the existing records' do
        result = described_class.random
        expect([service1, service2, service3]).to include(result)
      end

      it 'returns different results across multiple calls' do
        # ランダム性をテストするため、100回実行して異なる結果が返ることを確認
        results = 100.times.map { described_class.random }
        unique_results = results.uniq

        # 3つのレコードがあるので、理論的には3種類の結果が得られるはず
        # ただし確率的なテストなので、最低2種類以上が返ることを確認
        expect(unique_results.size).to be >= 2
      end
    end
  end
end
