class User < ApplicationRecord
  has_many :visited_places, dependent: :destroy
  has_many :places, through: :visited_places

  class << self
    def find_or_create_from_auth_hash(auth_hash)
      user_params = user_params_from_auth_hash(auth_hash)
      find_or_create_by(email: user_params[:email]) do |user|
        user.update(user_params)
      end
    end

    private

    def user_params_from_auth_hash(auth_hash)
      {
        name: auth_hash.info.name,
        email: auth_hash.info.email,
        image: auth_hash.info.image,
      }
    end
  end

  def x_share_url
    url = Rails.application.routes.url_helpers.user_visited_places_url(id)
    text = places.map { _1.name }.join("、") + "に行きました。"
    "https://x.com/share?url=#{url}&text=#{text}"
  end
end
