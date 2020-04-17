#!/usr/bin/env ruby
require 'io/console'

class SaveLoad
  SAVE_DATA_FILE = 'save.conf'

  attr_accessor :data_changed

  def initialize
    self.data_changed = false
  end

  module Config
    def self.add key, value
      @@data ||= {}
      @@data[key] = value
    end

    def self.data
      @@data ||= {}
    end
  end

  def show_change_data_menu
    puts 'Change Data'
    puts '-----------'
    puts
    puts " (1) Name: #{Config.data['name']}"
    puts " (2) Age: #{Config.data['age']}"
    puts " (3) Hometown: #{Config.data['hometown']}"
    puts
    puts ' (q) Back to main menu'
    puts
    print 'data> '
    choice = STDIN.getch.downcase

    case choice
    when '1'
      print 'Name: '
      answer = gets.chomp

      unless answer.empty?
        if Config.data['name'].nil?
          Config.add 'name', answer
        else
          Config.data['name'] = answer
        end
        self.data_changed = true
      end
      show_change_data_menu
    when '2'
      print 'Age: '
      answer = gets.chomp

      unless answer.empty?
        if Config.data['age'].nil?
          Config.add 'age', answer
        else
          Config.data['age'] = answer
        end
        self.data_changed = true
      end
      show_change_data_menu
    when '3'
      print 'Hometown: '
      answer = gets.chomp

      unless answer.empty?
        if Config.data['hometown'].nil?
          Config.add 'hometown', answer
        else
          Config.data['hometown'] = answer
        end
        self.data_changed = true
      end
      show_change_data_menu
    when 'q', 'x'
      puts
      return
    else
      show_change_data_menu
    end
  end

  def show_main_menu
    puts 'Main Menu'
    puts '---------'
    puts
    puts ' (1) Display loaded data'
    puts ' (2) Change data'
    puts ' (3) Read from save file'
    puts ' (4) Write to save file'
    puts
    puts ' (q) Quit from script'
    puts
    print 'menu> '
    choice = STDIN.getch.downcase
    
    case choice
    when '1'
      puts choice
      display_loaded_data
      show_main_menu
    when '2'
      puts choice
      show_change_data_menu
      show_main_menu
    when '3'
      puts choice
      read_from_save
      show_main_menu
    when '4'
      puts choice
      write_to_save
      show_main_menu
    when 'x', 'q'
      puts choice
      if data_changed
        puts 'You changed stuff. Do you want to save before exiting? (y/n)'
        answer = STDIN.getch.downcase
        
        case answer
        when 'y'
          write_to_save
        end
      end
      puts "Exiting..."
      exit
    else
      show_main_menu
    end
  end

  def display_loaded_data
    if Config.data.empty?
      puts 'No loaded data yet.'
      puts
    else
      Config.data.each do |key, val|
        puts "#{key} : #{val}"
      end
      puts
    end
  end

  def read_from_save
    if File.exist?(SAVE_DATA_FILE)
      #save_data = YAML.load_file(SAVE_DATA_FILE)
      
      print 'Overwrite current session with saved data? (y/n) '
      a = STDIN.getch.chomp.downcase
      
      case a
      when 'y'
        File.open(SAVE_DATA_FILE).readlines.each do |line|
          l = line.split(':')
          Config.add l[0], l[1]
        end
        puts "Successfully read from #{SAVE_DATA_FILE}"
        puts
      end
    else
      puts 'No save file.'
    end
  end

  def write_to_save
    File.open(SAVE_DATA_FILE, 'w') do |f|
      Config.data.each do |key, val|
        f.puts "#{key}:#{val}"
      end
    end
    puts "Wrote to #{SAVE_DATA_FILE}"
    puts
  end
end

puts 'Welcome to the Save/Load data test!'
puts
sl = SaveLoad.new
sl.show_main_menu
