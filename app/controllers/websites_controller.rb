class WebsitesController < ApplicationController
  before_filter :authenticate_user!
  require 'open-uri'
  def index
    @notice = ''
    @notice = params[:notice] if params[:notice].present?
    @website = Website.new
    @urls = current_user.websites
  end

  def create
    @old_rank = 0
    @website = current_user.websites.find_by_url_name(params[:website][:url_name])
    if @website.present?
      @website.ranks.each do |rank|
        @old_rank = rank.rank
      end
      RankScrapJob.perform_async(@website, @old_rank)
    else
      @website = current_user.websites.build(web_params)
      if @website.save
        RankScrapJob.perform_async(@website, @old_rank)
      else
        return redirect_to websites_index_path(notice: 'Your limit exceeds.')
      end
    end
    redirect_to action: 'show', id: @website
  end

  def show
    @website = Website.find(params[:id])
  end

  def destroy
    record = current_user.websites.find(params[:id].to_i)
    if record.destroy
      return redirect_to websites_index_path(notice: 'Domain deleted successfully')
    end
    redirect_to websites_index_path
  end

  private

  def web_params
    params.require(:website).permit(:url_name, :user_id)
  end

  def base_url
    'http://www.alexa.com/siteinfo/'
  end

  def search_site_name
    params[:search].present? ? params[:search].to_s : ''
  end

  def custom_url
    base_url + search_site_name
  end
end