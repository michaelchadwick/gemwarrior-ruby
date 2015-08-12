# lib/gemwarrior/misc/wordlist.rb
# List of words for flavor text, hopefully randomized from Wordnik

require 'http'
require 'json'

module Gemwarrior
  class WordList
    STATIC_ADJECTIVE_VALUES = [
      '5 o\'clock-shadowed', 'angry', 'aristocratic', 'calm', 'choice', 'clinical', 'cracked', 'depressed', 'dingy', 'excited', 'ginormous', 'handsome', 'hydrothermal', 'lackadaisical', 'man-sized', 'moist', 'non-venomous', 'picaresque', 'positive', 'relaxed', 'ruddy', 'smooth', 'shocked', 'sticky', 'tense', 'tingly', 'tired', 'toneless', 'unpolished', 'worn'
    ]
    STATIC_NOUN_VALUES = [
      'arrestor', 'blockhead', 'busker', 'candlestick', 'cigarette', 'clavinet', 'cursor', 'degeneration', 'devotchka', 'drive', 'earthquake', 'genie', 'granddaddy', 'haunter', 'heater', 'locality', 'nitrogen', 'quitter', 'raccoon', 'radish', 'recession', 'sheepdog', 'smorgasbord', 'softener', 'sphere', 'stage-hand', 'tsunami', 'tuber', 'whatsit', 'zillionaire'
    ]
    STATIC_NOUN_PLURAL_VALUES = [
      'abutments', 'asterisms', 'bains', 'blebs', 'blowholes', 'chapes', 'civility', 'crocuses', 'dancers', 'deniers', 'diastoles', 'dinges', 'dualism', 'ebullitions', 'extremities', 'fingering', 'gabardines', 'gullets', 'knops', 'nooks', 'payments', 'phaetons', 'scalawags', 'snickers', 'specters', 'splats', 'squiggles', 'thalamuses', 'wallets', 'xylophones'
    ]
    STATIC_VERB_VALUES = [
      'accentuate', 'accompany', 'blatter', 'bully', 'collide', 'crusade', 'disallow', 'entitle', 'infest', 'lateral', 'micturate', 'mourn', 'munge', 'numb', 'outdraw', 'overstep', 'plummet', 'refill', 'refurnish', 'reroute', 'rumple', 'scupper', 'smoosh', 'spifflicate', 'straighten', 'synthesize', 'terrorize', 'unshift', 'vociferate'
    ]

    attr_accessor :use_wordnik, :type, :limit, :words, :error

    def initialize(use_wordnik = false, type = 'noun', limit = 10)
      self.use_wordnik  = use_wordnik
      self.type         = type
      self.limit        = limit
      self.words        = populate_words(type, limit)
      self.error        = nil
    end

    def get_random_value
      random_value = words[rand(0..limit)]

      return random_value.nil? ? get_random_value : random_value
    end

    def list_words
      words.join(',')
    end

    private

    def populate_words(type, limit = 10)
      url = 'http://api.wordnik.com:80/v4/words.json/randomWords'
      api_key = ENV['WORDNIK_API_KEY']

      unless api_key.nil? || use_wordnik == false
        case type
        when 'noun', 'noun-plural', 'adjective', 'verb'
        else
          error = 'invalid wordlist type'
          return
        end

        json_return = HTTP.get(
          url, 
          params: { 
            hasDictionaryDef:     true,
            includePartOfSpeech:  type,
            minCorpusCount:       1,
            maxCorpusCount:       -1,
            minDictionaryCount:   1,
            maxDictionaryCount:   -1,
            minLength:            5,
            maxLength:            12,
            sortBy:               'alpha',
            sortOrder:            'asc',
            limit:                limit,
            api_key:              api_key
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
            return get_static_values(type)
          end
        end
      end

      return get_static_values(type)
    end

    def get_static_values(type = nil)
      static_values = []
      0.upto(10) do
        case type
        when 'noun'
          static_values.push(STATIC_NOUN_VALUES[rand(0..STATIC_NOUN_VALUES.length-1)])
        when 'noun-plural'
          static_values.push(STATIC_NOUN_PLURAL_VALUES[rand(0..STATIC_NOUN_PLURAL_VALUES.length-1)])
        when 'adjective'
          static_values.push(STATIC_ADJECTIVE_VALUES[rand(0..STATIC_ADJECTIVE_VALUES.length-1)])
        when 'verb'
          static_values.push(STATIC_VERB_VALUES[rand(0..STATIC_VERB_VALUES.length-1)])
        else
          error = 'invalid wordlist type'
          return 
        end
      end
      return static_values
    end

  end
end
