class SubwayService
  require "protobuf"
  require "google/transit/gtfs-realtime.pb"

  @api_key = Rails.application.secrets.MTA_SUBWAY_API_KEY

  def self.get_arrivals(stop)
    nb, sb = {}, {}

    unless stop.nil?
      for route in stop.routes
        feed = get_feed(route)
        for entity in feed.entity
          if entity.field?(:trip_update)
            entity.trip_update.stop_time_update.each do |item|
              route_id = entity.trip_update.trip.route_id
              mins_away = item.arrival.nil? ? 0 : (item.arrival.time - DateTime.now.to_time.to_i) / 60
              if item.stop_id == stop.gtfs_id + "N"
                nb[route_id] = [] unless nb.has_key? route_id
                nb[route_id] << arriving(mins_away, item.arrival.time) if mins_away > 0 && nb[route_id].length < 4
              elsif item.stop_id == stop.gtfs_id + "S"
                sb[route_id] = [] unless sb.has_key? route_id
                sb[route_id] << arriving(mins_away, item.arrival.time) if mins_away > 0 && sb[route_id].length < 4
              end
            end
          end
        end
      end
    end

    # make sure the keys (i.e. services) are sorted
    nb = Hash[nb.sort_by { |key, value| key }]
    sb = Hash[sb.sort_by { |key, value| key }]
    # then sort the arrival times
    nb.each { |key, value| value = natural_sort(value) }
    sb.each { |key, value| value = natural_sort(value) }

    { "NB" => nb, "SB" => sb }
  end

  private

  class << self
    def get_feed(route)
      url = feeds_by_route(route)
      uri = URI.parse(url)

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(uri)
        req["x-api-key"] = @api_key
        http.request(req)
      end

      Transit_realtime::FeedMessage.decode(res.body)
    end

    def arriving(mins_away, arrival_time)
      timestamp = Time.at(arrival_time).strftime("%H:%M")
      "#{mins_away.to_s} min (#{timestamp})"
    end

    def natural_sort(array)
      array.sort_by! { |e| e.split(/(\d+)/).map { |a| a =~ /\d+/ ? a.to_i : a } }
    end

    def feeds_by_route(route)
      base = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs"
      feeds = {
        "#{base}" => ["1", "2", "3", "4", "5", "6", "6X", "GS"],
        "#{base}-7" => ["7", "7X"],
        "#{base}-ace" => ["A", "C", "E", "H", "FS"],
        "#{base}-bdfm" => ["B", "D", "F", "M"],
        "#{base}-nqrw" => ["N", "Q", "R", "W"],
        "#{base}-g" => ["G"],
        "#{base}-l" => ["L"],
        "#{base}-si" => ["SI"],
        "#{base}-jz" => ["J", "Z"],
      }
      feeds.each { |key, val|
        return key if val.include? route
      }
      nil
    end
  end
end
