module Moneta
  module Api
    module Responses
      class CreateAccountResponse
        include Moneta::Api::DataMapper

        property :id

        def initialize(response)
          @id = response
        end
      end
    end
  end
end
