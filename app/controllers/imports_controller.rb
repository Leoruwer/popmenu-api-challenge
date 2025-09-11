class ImportsController < ApplicationController
  def create
    begin
      data = JSON.parse(request.body.read)

      render json: { received: data }, status: :ok
    rescue JSON::ParserError => e
      render json: { message: "Invalid JSON: #{e.message}" }, status: :unprocessable_content
    end
  end
end
