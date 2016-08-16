module JellyfishMiq
  class ProvidersController < JellyfishMiq::ApplicationController
    after_action :verify_authorized

    private

    def provider
      @provider ||= ::Provider.find params[:id]
    end
  end
end
