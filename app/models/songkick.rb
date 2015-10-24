require 'httparty'
require 'json'
require 'pp'
require './JSON_parsed'

# require_relative 'songkick.rb'
# require_relative 'artist.rb'

module Songkick

  include HTTParty
  KEY = ENV['SONGKICK_API']
  p KEY

  base_uri "http://api.songkick.com/api/3.0"

  class Calendar

    attr_accessor :event_dates, :event_times, :tour_locations, :event_titles, :event_links, :calendar

    def initialize(data = {})
      artist_name = data[:artist_name]
      @event_dates =  event_dates_for(artist_name)
      @event_times = event_times_for(artist_name)
      @tour_locations = tour_locations_for(artist_name)
      @event_titles = event_titles_for(artist_name)
      @event_links = event_links_for(artist_name)
      @calendar = calendar_for(artist_name)
    end

    def calendar_for(artist_name)
      artist_id = Songkick::Artist.new(artist_name: artist_name).artist_id
      access_calendar_data(artist_id)
    end

    def event_dates_for(artist_name)
      calendar_data = calendar_for(artist_name)
      calendar_data["resultsPage"]["results"]["event"].map {|event| event["start"]["date"]}

      # replace calendar_data with below.

      # JSON.parse(calendar_data.body)["resultsPage"]["results"]["event"].map {|event| event["start"]["date"]}
    end

    def event_times_for(artist_name)
      calendar_data = calendar_for(artist_name)
      calendar_data["resultsPage"]["results"]["event"].map {|event| event["start"]["time"]}

      # JSON.parse(calendar_data.body)["resultsPage"]["results"]["event"].map {|event| event["start"]["time"]}
    end

    def tour_locations_for(artist_name)
      calendar_data = calendar_for(artist_name)
      lng_array = calendar_data["resultsPage"]["results"]["event"].map {|event| event["location"]["lng"]}
      lat_array = calendar_data["resultsPage"]["results"]["event"].map {|event| event["location"]["lat"]}

      # lng_array = JSON.parse(calendar_data.body)["resultsPage"]["results"]["event"].map {|event| event["location"]["lng"]}
      # lat_array = JSON.parse(calendar_data.body)["resultsPage"]["results"]["event"].map {|event| event["location"]["lat"]}

      lat_array.zip(lng_array)
    end

    def event_titles_for(artist_name)
      calendar_data = calendar_for(artist_name)
      calendar_data["resultsPage"]["results"]["event"].map {|event| event["displayName"]}
    end

    def event_links_for(artist_name)
      calendar_data = calendar_for(artist_name)
      calendar_data["resultsPage"]["results"]["event"].map {|event| event["uri"]}
    end

    private

    def access_calendar_data(artist_id)
      # artist = URI.escape(artist_id)
      search_string = "/artists/#{artist_id}/calendar.json?apikey=#{KEY}"
      # get(search_string)
      CALENDAR_DATA
    end
  end

  class Event

    attr_accessor :events, :date, :time

    def initialize(args = {})
      artist_name = args[:artist_name]
      @events = events_for(artist_name)
      @date = event_date_for(artist_name)
      @time = event_time_for(artist_name)
      @events_array = []
      @events_array
    end

    def events_for(artist_name)
      calendar_data = Songkick::Calendar.new(artist_name: "Tribal Seeds").calendar
      calendar_data["resultsPage"]["results"]["event"].map {|event| event}

      # replace calendar_data with below.

      # JSON.parse(calendar_data.body)["resultsPage"]["results"]["event"].map {|event| event["start"]["date"]}
    end

    def event_date_for(artist_name)
      events = events_for(artist_name)
      @date_array = events.map {|event| event["displayName"]}
    end

    # artist_calendar.event_dates.each do |date|
    #   p Songkick::Event.new(date: date)
    # end

    def event_time_for(artist_name)
      events = events_for(artist_name)
      @time_array = events.map {|event| event["start"]["time"]}
      @time_array.zip(@date_array)
    end

    # artist_calendar.tour_locations.each do |location|
    #   p location
    # end

    # artist_calendar.event_titles.each do |title|
    #   p title
    # end

    # artist_calendar.event_links.each do |link|
    #   p link
    # end

  end

  class Artist

    attr_accessor :artist_id, :artist_displayname


    def initialize(data = {})
      @artist_name = data[:artist_name]
      @artist_id = artist_id_for(data[:artist_name])
      @artist_displayname = artist_displayname_for(data[:artist_name])
    end

    def access_artist_id(artists_data)
        artists_data["resultsPage"]["results"]["artist"].first["id"]
        # JSON.parse(artists_data.body)["resultsPage"]["results"]["artist"].first["id"]
    end

    # def self.access_artist_id(artists_data)
      # JSON.parse(artists_data.body)["resultsPage"]["results"]["artist"].first["id"]
    # end

    def artist_id_for(artist_name)
      access_artist_id(access_artist_data(artist_name))
    end

    def artist_displayname_for(artist_name)
      artist_data = access_artist_data(artist_name)
      artist_data["resultsPage"]["results"]["artist"].first["displayName"]
      # artist_data = access_artist_data(artist_name)
      # JSON.parse(artist_data.body)["resultsPage"]["results"]["artist"].first["displayName"]
    end

    private

    def access_artist_data(artist_name)
      artist = URI.escape(artist_name)
      search_string = "/search/artists.json?query=#{artist}&apikey=#{KEY}"
      # p get(search_string)  # be careful!  you may get multiple back!!!
      ARTIST_DATA
    end

  end

end

# p Songkick::Calendar.new(artist_name: "Tribal Seeds").calendar

p Songkick::Artist.new(artist_name: "Tribal Seeds").artist_displayname

pp Songkick::Event.new(artist_name: "Tribal Seeds").date
pp Songkick::Event.new(artist_name: "Tribal Seeds").time



