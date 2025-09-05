# frozen_string_literal: true

module Tools
  class AwsServiceTool
    extend Langchain::ToolDefinition

    define_function :get_random_service, description: 'AwsServiceTool: Get a random AWS service'

    def get_random_service
      service = AwsService.random

      { name: service.name, description: service.description }
    end
  end
end
