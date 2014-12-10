class HealthCheckController < ApplicationController
  skip_before_filter :authenticate_user_from_token!, :authenticate_user!

  def index
    expires_now

    if mongo_health
      render inline: 'OK', status: :ok, content_type: 'text/plain'
    else
      render inline: 'NOT OK', status: '500', content_type: 'text/plain'
    end
  end

  private

  def mongo_health
    !Mongoid::Sessions.default.command(ping: 1).nil?
  rescue
    nil
  end
end
