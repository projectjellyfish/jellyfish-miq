module JellyfishMiq
  class Engine < ::Rails::Engine
    isolate_namespace JellyfishMiq

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    # Initializer to combine this engines static assets with the static assets of the hosting site.
    initializer 'static assets' do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
    end

    initializer 'jellyfish_miq.load_default_settings', before: :load_config_initializers do
      begin
        if ::Setting.table_exists?
          Dir[File.expand_path '../../../app/models/jellyfish_miq/setting/*.rb', __FILE__].each do |file|
            require_dependency file
          end
        end
      rescue
        # ignored
        nil
      end
    end

    initializer 'jellyfish_miq.load_product_types', before: :load_config_initializers do
      begin
        if ::ProductType.table_exists?
          Dir[File.expand_path '../../../app/models/jellyfish_miq/product_type/*.rb', __FILE__].each do |file|
            require_dependency file
          end
        end
      rescue
        # ignored
        nil
      end
    end

    initializer 'jellyfish_miq.load_registered_providers', before: :load_config_initializers do
      begin
        if ::RegisteredProvider.table_exists?
          Dir[File.expand_path '../../../app/models/jellyfish_miq/registered_provider/*', __FILE__].each do |file|
            require_dependency file
          end
        end
      rescue
        # ignored
        nil
      end
    end

    initializer 'jellyfish_miq.register_extension', after: :finisher_hook do |_app|
      Jellyfish::Extension.register 'jellyfish-miq' do
        requires_jellyfish '>= 4.0.0'

        load_scripts 'extensions/miq/components/forms/fields.config.js',
          'extensions/miq/resources/miq-data.factory.js',
          'extensions/miq/states/services/details/miq/automation/automation.state.js'

        mount_extension JellyfishMiq::Engine, at: :miq
      end
    end
  end
end
