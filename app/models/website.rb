class Website < ActiveRecord::Base
  belongs_to :user
  has_many :ranks, dependent: :destroy
  validates :url_name, presence: true
  validate :thing_count_within_limit, on: :create

  def thing_count_within_limit
    if user.websites(:reload).count >= 3
      errors.add(:base, 'Exceeded thing limit')
    end
  rescue Exception => e
  end

  def update_alexa_rank(old_rank)
    temp_url = custom_url(self)
    rank = fetch_rank(temp_url)
    if ranks.present?
      ranks.update_all(rank: rank, old_rank: old_rank)
    else
      ranks.create(rank: rank, old_rank: old_rank)
    end
  rescue Exception => e
    Rails.logger.info "#{url_name} rank fetch failed."
    Rails.logger.info e.message.to_s
  end

  private

  def fetch_rank(url)
    doc = ''
    doc = Nokogiri::HTML(open(url))
    rank_data = doc.at_css('.metrics-data').inner_text.to_s.delete(',').split.first
    rank_data.to_i
  end

  def base_url
    'http://www.alexa.com/siteinfo/'
  end

  def search_site_name(site)
    site.url_name.to_s
  end

  def custom_url(site)
    base_url + search_site_name(site)
  end
end
