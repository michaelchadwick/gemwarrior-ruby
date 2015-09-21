# lib/gemwarrior/misc/hr.rb
# Standardized, cross-platform horizontal rule
# Cribbed extensively from https://github.com/ivantsepp/hr

module Gemwarrior
  module Hr
    extend self

    def print(*patterns)
      Kernel.print string(*patterns)
    end

    def string(*patterns)
      options = patterns.last.is_a?(Hash) ? patterns.pop : {}
      column_width = get_column_width
      output = patterns.map do |pattern|
        pattern = pattern.to_s
        times = (column_width / pattern.length) + 1
        (pattern * times)[0..column_width - 1]
      end.join
      options = options.inject({}){|tmp,(k,v)| tmp[k.to_sym] = v.to_sym; tmp}
      options.any? ? output.colorize(options) : output
    end
    
    private
    
    def get_column_width
      column_width = 0

      begin
        require 'io/console'
        column_width = IO.console.winsize[1]
      rescue
        if command_exists?('tput')
          column_width = `tput cols`.to_i
        elsif command_exists?('stty')
          column_width = `stty size`.split.last.to_i
        elsif command_exists?('mode')
          mode_output = `mode`.split
          column_width = mode_output[mode_output.index('Columns:')+1].to_i
        end
      end

      case
      when column_width.nil?, column_width <= 0
        return 80
      else
        return column_width
      end
    end
    
    def command_exists?(command)
      ENV['PATH'].split(File::PATH_SEPARATOR).any? { |path|
        (File.exist? File.join(path, "#{command}")) || (File.exist? File.join(path, "#{command}.com")) || (File.exist? File.join(path, "#{command}.exe"))
      }
    end
  end
end
