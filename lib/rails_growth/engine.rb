require 'rails_com'
module RailsGrowth
  class Engine < ::Rails::Engine

    config.eager_load_paths += Dir[
      "#{config.root}/app/models/rails_growth",
      "#{config.root}/app/models/rails_growth/reward_incomes",
      "#{config.root}/app/models/rails_growth/coin_exchanges"
    ]

    config.generators do |g|
      g.rails = {
        assets: false,
        stylesheets: false,
        helper: false
      }
      g.test_unit = {
        fixture: true,
        fixture_replacement: :factory_bot
      }
      g.templates.unshift File.expand_path('lib/templates', RailsCom::Engine.root)
    end

    initializer 'rails_growth.assets.precompile' do |app|
      app.config.assets.precompile += ['rails_growth_manifest.js']
    end

  end
end
