module Moneta
  module Api
    class Service
      include ServiceMethods
      attr_reader :client

      def initialize(username, password, params = {})
        @client = Savon.client(prepare_params(username, password, params))
      end

      private

      def prepare_params(username, password, params)
        { wsdl: 'https://demo.moneta.ru/services.wsdl', wsse_auth: [ username, password ] }
      end
    end
  end
end
