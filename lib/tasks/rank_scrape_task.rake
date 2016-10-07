require 'rake'

task scrape_rank: :environment do
  websites = Website.all
  old_rank = 0
  websites.each do |site|
    site.ranks.each do |rank|
      old_rank = rank.rank
    end
    RankScrapJob.perform_async(site, old_rank)
  end
end
