require 'curb'
require 'nokogiri'

class Messenger

  def get_html(url)
    Nokogiri::HTML(Curl.get(url).body)
  end

  def send_message

    html = get_html('http://freesms.mts.by/cgi-bin/cgi.exe?function=sms_send&isFree=1').text
    File.open('1.html', 'w') { |f| f << html }
    # p captcha_num = html.xpath('//table[@class="grid-send"]/tbody/tr/td[@class="col"]/table/tbody/tr/td/img/@scr')
    # captcha_url = "http://freesms.mts.by/cgi-bin/cgi.exe?function=sms_show_antispam_image&ImageNumber=#{captcha_num}"
    # count = text.size
    # time = Time.now
    # day = time.day.to_s
    # mon = time.mon.to_s
    # year = time.year.to_s
    # hour = time.hour.to_s
    # min = time.min
    # table_record_id = html.xpath('//td[@class="number"]/input[@type="hidden"]/@value').text

#     Curl.post('http://freesms.mts.by/cgi-bin/cgi.exe?function=sms_send', 
#       {
#         'MMObjectType' => '0',
#         'isFree' => '1',
#         'MMObjectID' => '',
#         'Prefix' => '375',
#         'To' => '375292771723',
#         'NDC' => '29',
#         'mobnum' => '2771723',
#         'Msg' => 'тест',
#         'count' => count,
#         'Day' => '25',
#         'Mon' => '10',
#         'Year' => '2015',
#         'Hour' => '16',
#         'Min' => '15',
#         'antispamText' => '3180',
#         'textTableRecordId' => captcha_id
#       }
# ).body
  end

end #class

p Messenger.new.send_message