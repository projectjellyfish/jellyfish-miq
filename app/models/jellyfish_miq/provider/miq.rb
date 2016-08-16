module JellyfishMiq
  module Provider
    class Miq < ::Provider
      def client
        @client ||= begin
          MockClient.new credentials
        end
      end

      private

      def credentials
        @credentials ||= begin
          {
            provider: 'MIQ',
            username: settings[:username],
            password: settings[:password]
          }
        end
      end
    end
    class MockClient
      attr_accessor :credentials
      def initialize(credentials)
        @credentials = credentials
      end
    end
  end
end
