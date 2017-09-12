class SummariesController < ApplicationController

  def search
    redirect_to summary_path(params[:q])
  end

  def show
    @summary = Summary.find_or_create_by(username: params[:username])
    @summary.get_user
    @summary.get_repos
    @summary.save
    @username = @summary.username
    @user = @summary.user
    @repos = @summary.repos
    @languages = @summary.languages
  end

end
