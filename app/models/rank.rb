class Rank < ActiveRecord::Base
  belongs_to :website

  def fetch_rank(custom_url)
    doc = ''
    doc = Nokogiri::HTML(open(custom_url))
    rank_data = doc.at_css('.metrics-data').inner_text.to_s.delete(',').split.first
    rank_data.to_i
  end
end
