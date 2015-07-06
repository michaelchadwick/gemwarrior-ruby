# lib/gemwarrior/misc/timer.rb
# Timer

module Gemwarrior
  class Timer
    attr_accessor :duration_in_s, :timer_name, :background, :progress, :verbose
  
    DEFAULTS = {
      duration_in_s: 1, 
      timer_name:    'Timer', 
      background:    false,
      progress:      false,
      verbose:       true
    }
  
    def initialize(options = {})
      options = DEFAULTS.merge(options)
      
      self.duration_in_s  = options[:duration_in_s]
      self.timer_name     = options[:timer_name]
      self.background     = options[:background]
      self.progress       = options[:progress]
      self.verbose        = options[:verbose]
    end

    def start
      if background
        Thread.start { self.run }
      else
        self.run
      end
    end
    
    def run
      puts "#{timer_name} began at #{Time.now} for #{duration_in_s} seconds" if verbose
      
      end_time = Time.now + duration_in_s
      
      loop do
        sleep 1
        print '.' if progress
        if Time.now >= end_time
          print "\n"
          puts "#{timer_name} ended at #{Time.now}" if verbose
          return
        end
      end
    end
  end
end
