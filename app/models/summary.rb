class Summary < ApplicationRecord
  validates :username, uniqueness: true

  include HTTParty
  base_uri 'https://api.github.com'

  GITHUB_API_URL = 'https://api.github.com'

  def user
    user_response
  end

  def repos
    repos_response.sort do |a, b|
      b["pushed_at"].to_date <=> a["pushed_at"].to_date
    end
  end

  def get_user
    url = "#{GITHUB_API_URL}/users/#{username}"
    self.user_response = authenticated_get(url)
  end

  def get_repos
    url = "#{GITHUB_API_URL}/users/#{username}/repos"
    response = authenticated_get(url)
    self.repos_response = response.to_a
  end

  def ready?
    user_response.present? && repos_response.present?
  end

  def fetch_data!
    get_user
    get_repos
    save
  end

  def authenticated_get(url)
  response = HTTParty.get(url, headers: {
      "Authorization": "token #{ENV["GITHUB_PERSONAL_ACCESS_TOKEN"]}", "User-Agent": "deansy11"
      })

    if response.code >= 200 && response.code < 300
      response
    else
      raise response.body
    end
  end

  def languages
    repos
    .map { |repo| repo["language"] }
    .reject { |lang| lang.blank? }
    .uniq
    .sort
    .join(", ")
  end

end
