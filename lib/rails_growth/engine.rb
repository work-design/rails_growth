module RailsGrowth
  class Engine < ::Rails::Engine

    config.eager_load_paths += Dir[
      "#{config.root}/app/models/rails_growth",
      "#{config.root}/app/models/rails_growth/reward_incomes"
    ]

  end
end
