module JellyfishMiq
  module Service
    class Automation < ::Service::Compute
      def actions
        actions = super.merge :terminate
        actions
      end

      def deprovision
        handle_errors do
          update_status(::Service.defined_enums['status']['terminated'], 'terminated')
        end
      end

      def provision
        handle_errors do
          miq_host = self.provider.answers.where(name: 'host').last.value
          miq_username = self.provider.answers.where(name: 'username').last.value
          miq_password = self.provider.answers.where(name: 'password').last.value
          miq_namespace = self.answers.where(name: 'uri_namespace').last.value
          miq_class = self.answers.where(name: 'uri_class').last.value
          miq_instance = self.answers.where(name: 'uri_instance').last.value

          timeout = 60
          auth = { username: miq_username, password: miq_password }
          automation_endpoint = "https://#{miq_host}/api/automation_requests"
          headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

          uri_parts = {}
          uri_parts['namespace'] = miq_namespace
          uri_parts['class'] = miq_class
          uri_parts['instance'] = miq_instance
          body = { uri_parts: uri_parts, requester: { auto_approve: true } }.to_json

          # Make REST call to MIQ API
          response = {}
          request_id = nil
          begin
            response = HTTParty.post(automation_endpoint, basic_auth: auth, headers: headers, body: body, timeout: timeout, verify: false)
            request_id = response.dig('results',0,'id')
          rescue
          end

          # Setup details to be saved
          details = {
              request_id: request_id
          }

          # Save details to db
          save_outputs(details, [['Request ID', :request_id]], ValueTypes::TYPES[:string])

          # Update status of service to running
          update_status(::Service.defined_enums['status']['running'], 'running')
        end
      end

      private

      def update_status(status, status_msg)
        self.status = status
        self.status_msg = status_msg
        save
      end

      def save_outputs(source, outputs_to_save, output_value_type)
        outputs_to_save.each do |output_name, source_key|
          next unless defined? source[source_key]
          service = get_output(output_name) || service_outputs.new(name: output_name)
          service.update_attributes(value: source[source_key], value_type: output_value_type) unless service.nil?
          service.save
        end
      end

      def get_output(name)
        service_outputs.where(name: name).first
      end

      def handle_errors
        yield
      rescue Excon::Errors::BadRequest, Excon::Errors::Forbidden => e
        raise e, 'Request failed, check for valid credentials and proper permissions.', e.backtrace
      end

      def client
        @client ||= begin
          provider.client
        end
      end
    end
  end
end
