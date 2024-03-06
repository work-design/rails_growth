Rails.application.routes.draw do
  namespace 'growth', defaults: { business: 'growth' } do
    namespace :admin, defaults: { namespace: 'admin' } do
      resources :aims do
        get 'add_item/:item' => :add_item, on: :collection, as: :add_item
        get 'remove_item/:item' => :remove_item, on: :collection, as: :remove_item
        resources :aim_users, shallow: true, only: [:index, :show, :destroy]
        resources :aim_entities, shallow: true, only: [:index, :show, :destroy] do
          resources :aim_logs, only: [:index, :destroy]
        end
      end
      resources :aim_codes
      resources :rewards, shallow: true do
        resources :reward_incomes
      end
      resources :praise_incomes
      resources :reward_expenses
    end

    namespace :my, defaults: { namespace: 'my' } do
      resources :aim_logs, only: [:create]
      scope ':entity_type/:entity_id' do
        resources :aim_logs, only: [:create]
      end
      resources :rewards, only: [] do
        member do
          get :top
        end
        collection do
          get :top
        end
      end
      scope ':entity_type/:entity_id' do
        resources :rewards, only: [] do
          collection do
            get :top
          end
        end
      end
      resources :gifts, only: [:index] do
        collection do
          get :top
        end
        member do
          post :give
        end
      end
      scope ':entity_type/:entity_id' do
        resources :gifts, only: [] do
          post :give, on: :member
        end
      end
      resources :aims, only: [:index]
    end
  end

end
