module JellyfishMiq
  module Product
    class Automation < ::Product
      def order_questions
        [
        ]
      end

      def service_class
        'JellyfishMiq::Service::Automation'.constantize
      end

      private

      def init
        super
        self.img = 'products/redhat.png'
      end
    end
  end
end
