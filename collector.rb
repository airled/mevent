require 'nokogiri'
require 'curb'
require_relative './init/models'

class Collector

  def self.run
    current_page = source + '/jnp/music/index.html'
    while (current_page != source) do
      html = Nokogiri::HTML(Curl.get(current_page).body)
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

end
