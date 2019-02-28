require 'active_support/configurable'

module RailsGrowth
  include ActiveSupport::Configurable

  configure do |config|
    config.admin_class = 'AdminController'
    config.my_class = 'MyController'
    config.api_class = 'ApiController'
    config.disabled_models = []

    config.gift_purchase = 'Coin'
    config.reward_purchase = 'Coin'
    config.rate_to_reward = 0.3
    config.rate_to_royalty = 0.5
  end

end
