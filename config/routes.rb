Rails.application.routes.draw do
  resources :players, only: %i[create update] do
    collection do
      post :login
      put :update_picture
    end
  end

  resources :boards, only: %i[index create show] do
    member do
      post :join
      post :start_game
      post :bet_wins
      post :throw_card
      get :cards
    end
  end
end
