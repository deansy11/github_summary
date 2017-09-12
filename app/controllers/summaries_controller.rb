class SummariesController < ApplicationController

  def search
    redirect_to summary_path(params[:q])
  end

  def show
    @summary = Summary.find_or_create_by(username: params[:username])

    LoadPageJob.perform_later(@summary)

    if request.xhr?
      if @summary.ready?
        head 200
      else
        head 202
      end
    end

    # unless @summary.ready?
    #   @summary.fetch_data!
    # end

    @username = @summary.username
    @user = @summary.user
    @repos = @summary.repos
    @languages = @summary.languages

  end
end
