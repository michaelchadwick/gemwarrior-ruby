# lib/gemwarrior/misc/formatting.rb
# Formatting methods for text

module Gemwarrior
  module Formatting
    def self.upstyle(str_arr, no_space = false)
      if str_arr.is_a? Array
        str_arr_upstyled = []

        str_arr.each do |str_arr_item|
          str_arr_item_upstyled = []
          
          str_arr_item.split(' ').each do |s|
            str_arr_item_upstyled << upstyle_string(s, no_space)
          end

          str_arr_upstyled << str_arr_item_upstyled.join(' ')
        end

        str_arr_upstyled
      else
        upstyle_string(str_arr, no_space)
      end
    end

    def to_hooch(s)
      words = s.split(' ')
      words_hooched = []

      words.each do |w|
        if rand(0..100) > 60 and w.length > 1
          w = w.split('')
          w = w.insert(rand(0..w.length-1), '*HIC*')
          w = w.join('')
        end
        words_hooched << w
      end

      words_hooched.join(' ')
    end

    private

    def self.upstyle_string(s, no_space)
      s_upstyle = ''
      s_upstyle << s[0].upcase
      1.upto(s.length-1) do |i|
        if s[i-1].eql?('_')
          s_upstyle[i-1] = no_space ? '' : ' '
          s_upstyle << s[i].upcase
        else
          s_upstyle << s[i].downcase
        end
      end
      s_upstyle
    end
  end
end
