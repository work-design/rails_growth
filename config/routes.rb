Rails.application.routes.draw do

  scope module: 'growth' do

  end

  scope :admin, module: 'growth/admin', as: 'admin' do
    resources :aims do
      get 'add_item/:item' => :add_item, on: :collection, as: :add_item
      get 'remove_item/:item' => :remove_item, on: :collection, as: :remove_item
      resources :aim_users, shallow: true
      resources :aim_entities, shallow: true, except: [:new, :create] do
        resources :aim_logs, only: [:index, :destroy]
      end
    end
    resources :rewards, shallow: true do
      resources :reward_incomes
      resources :reward_expenses
    end
  end

  scope :api, module: 'growth/api', as: :api do
    scope ':entity_type/:entity_id' do
      resources :aim_logs, only: [:create]
    end
    resources :aims, only: [:index]
  end

end
