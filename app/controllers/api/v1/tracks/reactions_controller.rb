# frozen_string_literal: true

class Api::V1::Tracks::ReactionsController < Api::BaseController
  include Authorization

  before_action -> { doorkeeper_authorize! :write }
  before_action :require_user!
  before_action :set_status

  respond_to :json

  def create
    Reaction.push_account(
      current_account,
      track: @status.track,
      text: params.require(:text)
    )

    render json: @status, serializer: REST::StatusSerializer
  end

  def destroy
    Reaction.destroy_account(
      current_account,
      track: @status.track,
      text: params.require(:text)
    )

    render json: @status, serializer: REST::StatusSerializer
  end

  private

  def set_status
    @status = Status.find(params.require(:id))
  end
end