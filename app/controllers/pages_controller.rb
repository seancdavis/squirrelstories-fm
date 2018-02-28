class PagesController < ApplicationController

  def home
    @quote = Sapwood::QuoteService.get_all.shuffle.first
    @episodes = Sapwood::EpisodeService.get_all.first(2)
  end

  def show
    @page = Sapwood::PageService.get_by_path(params[:slug])
    not_found if @page.blank?
    render @page.template.underscore
  end

end
