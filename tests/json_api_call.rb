require 'http'
require 'json'

url = 'http://api.wordnik.com:80/v4/words.json/randomWords'

json_return = HTTP.get(
  url, 
  :params => { 
    :hasDictionaryDef => true,  
    :includePartOfSpeech => 'noun-plural', 
    :minCorpusCount => 10, 
    :maxCorpusCount => -1, 
    :minDictionaryCount => 1,
    :maxDictionaryCount => -1,
    :minLength => 5,
    :maxLength => 12,
    :sortBy => 'alpha',
    :sortOrder => 'asc',
    :limit => 10,
    :api_key => '63f5001dfacf2d619230e08591702875786da258b471becb6'
  }
)

if json_return
  json_data = JSON.parse(json_return.to_s)
  
  if json_data.include?("type") && json_data.include?("message")
    puts "wordnik error: #{json_data["message"]}"
  else
    word_list = []
    json_data.map {|j| word_list.push(j["word"])}
    if word_list.length > 0
      p word_list
    else
      puts 'no words received'
    end
  end
else
  puts "json error: #{json_return.to_s}"
end


