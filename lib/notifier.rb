#!/usr/bin/env ruby
require 'coinbase/exchange'
require 'faraday'
require 'json'
require 'pry'

class Notifier
  def initialize(seconds)
    @rest_api = Coinbase::Exchange::Client.new(
      ENV['GDAX_API_KEY'],
      ENV['GDAX_API_SECRET'],
      ENV['GDAX_API_PASS']
    )
    @maker_event = ENV.fetch('MAKER_EVENT')
    @maker_key = ENV.fetch('MAKER_KEY')
    @fill_cache = create_fill_cache(seconds)
  end

  def create_fill_cache(seconds)
    fills(Time.now.utc - seconds).map { |m| m['order_id'] }
  end

  def fills(start_date = Time.now.utc)
    @rest_api.fills(start_date: start_date)
  end

  def poll(frequency = 1)
    while true
      check_seconds = frequency * 60 * 60
      fills(Time.now.utc - check_seconds).each do |fill|
        next unless @fill_cache.include? fill['order_id']

        puts fill['order_id']
        @fill_cache << fill['order_id']
        send_notification(fill)
      end
      sleep(frequency)
    end
  end

  def send_notification(fill)
    product_id = fill['product_id']
    side = fill['side'].capitalize
    size = fill['size'].to_f.round(2)
    price = fill['price'].to_f.round(4)
    info = "#{size} @ #{price}"

    conn = Faraday.new('https://maker.ifttt.com/')
    conn.post do |req|
      req.url "/trigger/#{@maker_event}/with/key/#{@maker_key}"
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        value1: product_id,
        value2: side,
        value3: info
      }.to_json
    end
  end
end
