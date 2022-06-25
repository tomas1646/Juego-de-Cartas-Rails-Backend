class Player < ApplicationRecord
  validates :name, :user_name, :password, presence: true
  validates :user_name, uniqueness: true

  before_create :set_token
  has_one_attached :avatar

  def json
    { name:, user_name:, token:, avatar_url: }
  end

  private

  def set_token
    self.token = SecureRandom.uuid
  end

  def avatar_url
    avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_path(avatar, only_path: true) : ''
  end
end
