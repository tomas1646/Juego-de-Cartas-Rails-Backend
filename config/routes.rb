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
      post :start_card_round
      post :set_wins
      post :update_score
      post :throw_card
      post :end_card_round
      post :end_game
      get :cards
      get :test_test
    end
  end
end
