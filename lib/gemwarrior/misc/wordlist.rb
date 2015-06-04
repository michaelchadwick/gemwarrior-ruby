# lib/gemwarrior/wordlist.rb
# List of words for flavor text, hopefully randomized from Wordnik

require 'http'
require 'json'

module Gemwarrior
  class WordList
    STATIC_NOUN_VALUES = ["abutments", "asterisms", "bains", "blebs", "blowholes", "chapes", "civility", "crocuses", "dancers", "deniers", "diastoles", "dinges", "dualism", "ebullitions", "extremities", "fingering", "gabardines", "gullets", "knops", "nooks", "payments", "phaetons", "scalawags", "snickers", "specters", "splats", "squiggles", "thalamuses", "wallets", "xylophones"]
  
    attr_accessor :type, :limit, :words, :error
  
    def initialize(type, limit = 10)
      self.type = type
      self.limit = limit
      self.words = populate_words(type, limit)
      self.error = nil
    end

    def get_random_value
      random_value = words[rand(0..limit)]

      if random_value.nil?
        get_random_value
      else
        return random_value
      end
    end
    
    def list_words
      words.join(',')
    end

    private

    def populate_words(type, limit = 10)
      url = 'http://api.wordnik.com:80/v4/words.json/randomWords'
      api_key = ENV['WORDNIK_API_KEY']

      case type
      when 'noun', 'noun-plural', 'adjective', 'verb'
      else
        return get_static_values
      end
      
      json_return = HTTP.get(
        url, 
        :params => { 
          :hasDictionaryDef => true,  
          :includePartOfSpeech => type, 
          :minCorpusCount => 1, 
          :maxCorpusCount => -1, 
          :minDictionaryCount => 1,
          :maxDictionaryCount => -1,
          :minLength => 5,
          :maxLength => 12,
          :sortBy => 'alpha',
          :sortOrder => 'asc',
          :limit => limit,
          :api_key => api_key
        }
      )
      
      json_data = JSON.parse(json_return.to_s)

      if json_data.include?('type') && json_data.include?('message')
        error = "wordnik #{json_data['type']}: #{json_data['message']}"
        return get_static_values
      else
        word_list = []
        json_data.map {|j| word_list.push(j['word'])}
        if word_list.length > 0
          return word_list
        else
          error = 'Empty array from Wordnik'
          return get_static_values
        end
      end
    end
    
    def get_static_values
      static_values = []
      0.upto(10) do
        static_values.push(STATIC_NOUN_VALUES[rand(0..STATIC_NOUN_VALUES.length-1)])
      end
      return static_values
    end

  end
end