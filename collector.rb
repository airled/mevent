require 'nokogiri'
require 'curb'
require_relative './init/models'

class Collector

  def run
    source = 'http://www.ticketpro.by'
    current_page = source + '/jnp/music/index.html'
    while (current_page != source) do
      html = get_html(current_page)
      p current_page
      html.xpath('//div[@class="eventInfo"]').map do |event|
        name = event.xpath('.//h3').text.strip
        place = event.xpath('.//p[1]').text.strip
        date = event.xpath('.//p[2]').text.strip
        pic_url = source + event.xpath('../div[@class="eventImage"]/div[@class="eventPoster"]/a/img/@src').text.strip
        Concert.create(name: name, place: place, date: date, pic_url: pic_url)
      end
      current_page = source + html.xpath('//a[@class="normal"]/@href').text
    end
  end

  private

  def get_html(url)
    Nokogiri::HTML(Curl.get(url).body)
  end

end

Collector.new.run
