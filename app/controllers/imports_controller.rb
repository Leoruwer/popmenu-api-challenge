class ImportsController < ApplicationController
  def create
    data = request.body.read
    importer = JsonImporter.new(data)
    result = importer.call

    if result[:success]
      render json: { message: "Data imported successfully" }, status: :ok
    else
      Rails.logger.info "Import failed: #{result[:error]}"

      render json: { message: result[:error] }, status: :unprocessable_content
    end
  end
end
