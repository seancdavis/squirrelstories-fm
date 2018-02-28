class EpisodesController < ApplicationController

  caches_action :index, :show

  def index
    @episodes = Sapwood::EpisodeService.get_all
  end

  def show
    @episode = Sapwood::EpisodeService.get(params[:id])
  end

end
