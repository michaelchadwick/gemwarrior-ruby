# lib/gemwarrior/misc/hr.rb
# Standardized, cross-platform horizontal rule
# Cribbed extensively from https://github.com/ivantsepp/hr

require_relative '../game_options'

module Gemwarrior
  module Hr
    extend self

    def print(*patterns)
      Kernel.print string(*patterns)
    end

    def string(*patterns)
      options = patterns.last.is_a?(Hash) ? patterns.pop : {}
      screen_width = GameOptions.data['wrap_width']
      output = patterns.map do |pattern|
        pattern = pattern.to_s
        times = (screen_width / pattern.length) + 1
        (pattern * times)[0..screen_width - 1]
      end.join
      output << "\n"
      options = options.inject({}){|tmp,(k,v)| tmp[k.to_sym] = v.to_sym; tmp}
      options.any? ? output.colorize(options) : output
    end

    private

    def command_exists?(command)
      ENV['PATH'].split(File::PATH_SEPARATOR).any? { |path|
        (File.exist? File.join(path, "#{command}")) || (File.exist? File.join(path, "#{command}.com")) || (File.exist? File.join(path, "#{command}.exe"))
      }
    end
  end
end
