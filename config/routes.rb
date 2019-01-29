Rails.application.routes.draw do

  scope module: 'growth' do

  end

  scope :admin, module: 'growth/admin', as: 'admin' do
    resources :aims do
      get 'add_item/:item' => :add_item, on: :collection, as: :add_item
      get 'remove_item/:item' => :remove_item, on: :collection, as: :remove_item
      resources :aim_users, shallow: true, only: [:index, :show, :destroy]
      resources :aim_entities, shallow: true, only: [:index, :show, :destroy] do
        resources :aim_logs, only: [:index, :destroy]
      end
    end
    resources :rewards, shallow: true do
      resources :reward_incomes
    end
    resources :reward_expenses
  end

  scope :api, module: 'growth/api', as: :api do
    resources :aim_logs, only: [:create]
    scope ':entity_type/:entity_id' do
      resources :aim_logs, only: [:create]
    end
    resources :aims, only: [:index]
  end

end
