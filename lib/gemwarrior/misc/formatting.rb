# lib/gemwarrior/misc/formatting.rb
# Formatting methods for text

module Gemwarrior
  module Formatting
    def self.upstyle(str_arr)
      if str_arr.is_a? Array
        str_arr_upstyled = []
        
        str_arr.each do |str_arr_item|
          str_arr_item_upstyled = []
          
          str_arr_item.split(' ').each do |s|
            str_arr_item_upstyled << upstyle_string(s)
          end
          
          str_arr_upstyled << str_arr_item_upstyled.join(' ')
        end
        
        return str_arr_upstyled
      else
        return upstyle_string(str_arr)
      end
    end
    
    private
    
    def self.upstyle_string(s)
      s_upstyle = ''
      s_upstyle << s[0].upcase
      1.upto(s.length-1) do |i|
        if s[i-1].eql?('_')
          s_upstyle[i-1] = ' '
          s_upstyle << s[i].upcase
        else
          s_upstyle << s[i].downcase
        end
      end
      return s_upstyle
    end
  end
end
