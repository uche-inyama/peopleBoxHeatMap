class HeatmapController < ApplicationController
  def index 
    @dimension =  heatmap_params[:dimension]
    @start = heatmap_params[:start]
    @end = heatmap_params[:end]
    @response = Response.where('responses.created_at BETWEEN ? AND ?', @start, @end).joins(:employee).group(:driver_name).group(@dimension.to_sym).average(:score)
    drivers = []
    finalResult = []
    @response.each do |keys, value|
      driver_name, location, value = [keys.first, keys.last, value]
      if !drivers.include? driver_name
        drivers << driver_name
        finalResult << { driver: driver_name, scores: {} }
      end
      finalResult.last[:scores][location] = value.round(2)
    end
    render json: finalResult 
  end

  private

    def heatmap_params
      params.permit(:dimension, :start, :end)
    end
end
