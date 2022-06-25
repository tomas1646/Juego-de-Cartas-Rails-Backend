class Turn < ApplicationRecord
  belongs_to :round_played
  belongs_to :player
end
