# lib/gemwarrior/common.rb
# Common utility methods

module Gemwarrior
  module Textual
    class String
      def pluralize(n = nil)
        if n == 1
          "#{singular}"
        else
          "#{singular}s"
        end
      end
    end
  end
end
