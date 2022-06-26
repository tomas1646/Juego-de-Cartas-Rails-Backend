Rails.application.routes.draw do
  resources :players, only: %i[create update] do
    collection do
      post :login
      put :update_picture
    end
  end

  resources :boards, only: %i[index create show] do
    member do
      put :join
      put :start_game
      put :set_wins
      put :throw_card
      get :cards
    end
  end
end
