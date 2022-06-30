class HealthController < ApplicationController
  def alive
    render status: 200
  end
end
