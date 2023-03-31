class SubwayService
  require 'protobuf'
  require 'google/transit/gtfs-realtime.pb'

  @api_key = Rails.application.secrets.MTA_SUBWAY_API_KEY
  @base = 'https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs'

  def self.get_arrivals(stop)
    north = {}
    south = {}

    unless stop&.nil?
      stop.routes.each do |route|
        feed = get_feed(route)
        feed.entity.each do |entity|
          if entity.field?(:trip_update)
            entity.trip_update.stop_time_update.each do |item|
              route_id = entity.trip_update.trip.route_id
              mins_away = item.arrival.nil? ? 0 : minutes_away(item)

              case item.stop_id
              when "#{stop.gtfs_id}N"
                north[route_id] = [] unless north.key? route_id
                if mins_away.positive? && north[route_id].length < 4
                  north[route_id] << arriving(mins_away, item.arrival.time)
                end
              when "#{stop.gtfs_id}S"
                south[route_id] = [] unless south.key? route_id
                if mins_away.positive? && south[route_id].length < 4
                  south[route_id] << arriving(mins_away, item.arrival.time)
                end
              end
            end
          end
        end
      end
    end
    sort_hashes(north, south)
  end

  class << self
    def sort_hashes(north, south)
      # make sure the keys (i.e. services) are sorted
      north = Hash[north.sort_by { |key, _value| key }]
      south = Hash[south.sort_by { |key, _value| key }]
      # then sort the arrival times
      north.each { |_key, value| natural_sort(value) }
      south.each { |_key, value| natural_sort(value) }

      { 'NB' => north, 'SB' => south }
    end

    def minutes_away(item)
      (item.arrival.time - DateTime.now.to_time.to_i) / 60
    end

    def get_feed(route)
      url = feeds_by_route(route)
      uri = URI.parse(url)

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(uri)
        req['x-api-key'] = @api_key
        http.request(req)
      end

      Transit_realtime::FeedMessage.decode(res.body)
    end

    def arriving(mins_away, arrival_time)
      timestamp = Time.zone.at(arrival_time).strftime('%H:%M')
      "#{mins_away} min (#{timestamp})"
    end

    def natural_sort(array)
      array.sort_by! do |e|
        e.split(/(\d+)/).map do |a|
          a =~ /\d+/ ? a.to_i : a
        end
      end
    end

    def feeds_by_route(route)
      feeds = {
        @base.to_s => %w(1 2 3 4 5 6 6X GS),
        "#{@base}-7" => %w(7 7X),
        "#{@base}-ace" => %w(A C E H FS),
        "#{@base}-bdfm" => %w(B D F M),
        "#{@base}-nqrw" => %w(N Q R W),
        "#{@base}-g" => ['G'],
        "#{@base}-l" => ['L'],
        "#{@base}-si" => ['SI'],
        "#{@base}-jz" => %w(J Z)
      }
      feeds.each do |key, val|
        return key if val.include? route
      end
      nil
    end
  end
end
