module JellyfishMiq
  module RegisteredProvider
    class Miq < ::RegisteredProvider
      def self.load_registered_providers
        return unless super

        transaction do
          [
            set('MIQ', '76e53a7c-bfbb-4e1c-92a2-655be312e5d7')
          ].each { |s| create! s.merge!(type: 'JellyfishMiq::RegisteredProvider::Miq') }
        end
      end

      def provider_class
        'JellyfishMiq::Provider::Miq'.constantize
      end

      def description
        'MIQ Services'
      end

      def tags
        ['miq']
      end

      def questions
        [
          { name: :host, value_type: :string, field: :text, label: 'MIQ Host', required: true },
          { name: :username, value_type: :string, field: :text, label: 'MIQ Username', required: true },
          { name: :password, value_type: :password, field: :password, label: 'MIQ Password', required: :if_new }
        ]
      end
    end
  end
end
