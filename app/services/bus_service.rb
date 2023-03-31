class BusService
  @api_key = Rails.application.secrets.MTA_BUS_API_KEY

  class << self
    def get_arrivals(stop_id)
      data = JSON.parse(Net::HTTP.get(URI.parse(url(stop_id))))
      visits = data.dig('Siri', 'ServiceDelivery',
                        'StopMonitoringDelivery').first['MonitoredStopVisit']
      visits&.map do |visit|
        response(visit)
      end
    end

    private

    def response(visit)
      journey = visit['MonitoredVehicleJourney']
      call = journey['MonitoredCall']
      dists = call.dig('Extensions', 'Distances')
      {
        published_line_name: journey['PublishedLineName'],
        destination_name: journey['DestinationName'],
        expected_arrival_time: call['ExpectedArrivalTime'],
        presentable_distance: dists['PresentableDistance'],
        stops_from_call: dists['StopsFromCall']
      }
    end

    def url(stop_id)
      'http://bustime.mta.info/api/siri/stop-monitoring.json?key=' \
        "#{@api_key}&MonitoringRef=#{stop_id}"
    end
  end
end
