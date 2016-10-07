class RankScrapJob
  include SuckerPunch::Job

  def perform(website, old_rank)
    website.update_alexa_rank(old_rank)
  end
end
