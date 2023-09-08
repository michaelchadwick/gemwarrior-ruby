# lib/gemwarrior/repl.rb
# My own, simple, Read Evaluate Print Loop module

require 'readline'
require 'os'
require 'clocker'
require 'io/console'
require 'gems'
require 'ap'

require_relative 'misc/audio'
require_relative 'misc/timer'
require_relative 'misc/wordlist'
require_relative 'evaluator'
require_relative 'game_options'
require_relative 'version'

module Gemwarrior
  class Repl
    # CONSTANTS
    SCREEN_WIDTH_MIN        = 80
    SCREEN_WIDTH_MAX        = 120
    QUIT_MESSAGE            = 'Temporal flux detected. Shutting down...'.colorize(:red)
    MAIN_MENU_QUIT_MESSAGE  = 'Giving up so soon? Jool will be waiting...'.colorize(:red)
    SPLASH_MESSAGE          = 'Welcome to *Jool*, where randomized fortune is just as likely as mayhem.'
    GITHUB_NAME             = 'michaelchadwick'
    GITHUB_PROJECT          = 'gemwarrior'
    ERROR_SOUND_NOT_ENABLED = 'Sound is disabled! Enter \'x\' to exit'

    attr_accessor :game, :world, :evaluator

    def initialize(game, world, evaluator)
      self.game         = game
      self.world        = world
      self.evaluator    = evaluator

      GameOptions.data['wrap_width'] = get_screen_width
    end

    def get_screen_width
      screen_width = SCREEN_WIDTH_MIN

      begin
        require 'io/console'
        screen_width = IO.console.winsize[1]
      rescue
        if command_exists?('tput')
          screen_width = `tput cols`.to_i
        elsif command_exists?('stty')
          screen_width = `stty size`.split.last.to_i
        elsif command_exists?('mode')
          mode_output = `mode`.split
          screen_width = mode_output[mode_output.index('Columns:')+1].to_i
        end
      end

      case
      when screen_width.nil?, screen_width <= 0
        return SCREEN_WIDTH_MIN
      else
        return [screen_width, SCREEN_WIDTH_MAX].min
      end
    end

    def start(initial_command, extra_command, new_skip, resume_skip)
      setup_screen(initial_command, extra_command, new_skip, resume_skip)

      clocker = Clocker.new

      at_exit do
        update_duration(clocker.stop)
        game.update_options_file
        log_stats(world.duration, world.player)
        save_game(world)
      end

      clocker.clock do
        # main loop
        loop do
          prompt
          begin
            main_loop
          rescue Interrupt
            puts
            puts QUIT_MESSAGE
            exit
          end
        end
      end
    end

    def main_loop(ext_input = nil)
      input = ext_input.nil? ? read_line : ext_input
      result = evaluator.parse(input)
      if result.eql?('exit')
        exit
      elsif result.eql?('checkupdate')
        check_for_new_release
      else
        puts result
      end
    end

    # timer observer
    #def update(command)
    #  main_loop(command)
    #end

    private

    def clear_screen
      OS.windows? ? system('cls') : system('clear')
    end

    def read_line
      prompt_text = GameOptions.data['debug_mode'] ? ' GW[D]> ' : ' GW> '
      Readline.readline(prompt_text, true).to_s
    end

    def get_save_file_name
      if save_file_exist?
        File.open(GameOptions.data['save_file_yaml_path'], 'r') do |f|
          return YAML.unsafe_load(f)
        end
      end
    end

    def puts(s = '', width = GameOptions.data['wrap_width'])
      super s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n") unless s.nil?
    end

    def print_logo
      puts '/-+-+-+ +-+-+-+-+-+-+-\\'.colorize(:yellow)
      puts '|G|E|M| |W|A|R|R|I|O|R|'.colorize(:yellow)
      puts '\\-+-+-+ +-+-+-+-+-+-+-/'.colorize(:yellow)
      puts '[[[[[[[DEBUGGING]]]]]]]'.colorize(:white) if GameOptions.data['debug_mode']
    end

    def print_splash_message
      SPLASH_MESSAGE.length.times { print '=' }
      puts
      puts SPLASH_MESSAGE
      SPLASH_MESSAGE.length.times { print '=' }
      puts
    end

    def print_fortune
      noun1_values = WordList.new('noun-plural')
      noun2_values = WordList.new('noun-plural')
      noun3_values = WordList.new('noun-plural')

      puts "* Remember: #{noun1_values.get_random_value.colorize(:yellow)} and #{noun2_values.get_random_value.colorize(:yellow)} are the key to #{noun3_values.get_random_value.colorize(:yellow)} *\n\n"
      puts
    end

    def print_about_text
      puts 'Gem Warrior - A Game of Fortune and Mayhem'.colorize(:yellow)
      puts '=========================================='.colorize(:yellow)
      puts 'Gem Warrior is a text adventure roguelike-lite as a RubyGem created by Michael Chadwick (mike@neb.host) and released as open-source on Github. Take on the task set by Queen Ruby to defeat the evil Emerald and get back the ShinyThing(tm) he stole for terrible, dastardly reasons.'
      puts
      puts 'Explore the land of Jool with the power of text, fighting enemies to improve your station, grabbing curious items that may or may not come in handy, and finally defeating Mr. Emerald himself to win the game.'
    end

    def print_help_text
      puts 'Gem Warrior - Some Basic Help Commands'.colorize(:yellow)
      puts '======================================'.colorize(:yellow)
      puts '* Basic functions: look, go, character, inventory, attack *'
      puts '* Type \'help\' while in-game for complete list of commands *'
      puts '* Most commands can be abbreviated to their first letter  *'
      puts '* Note: if something isn\'t working, try:                  *'
      puts '*   1) starting a new game                                *'
      puts '*   2) updating the game                                  *'
    end

    def display_log_of_attempts
      if File.exist?(GameOptions.data['log_file_path']) and !File.zero?(GameOptions.data['log_file_path'])
        File.open(GameOptions.data['log_file_path']).readlines.each do |line|
          print "#{line}"
        end
        if GameOptions.data['debug_mode']
          print 'Clear log of attempts? (y/n) '
          answer = gets.chomp.downcase

          case answer
          when 'y', 'yes'
            File.truncate(GameOptions.data['log_file_path'], 0)
            puts 'Log of attempts: erased!'
          end

          puts
        end
      else
        puts 'No attempts made yet!'
      end
    end

    def check_for_new_release
      new_release_available = false
      puts 'Checking releases...'
      remote_release = Gems.versions('gemwarrior').first['number']
      local_release = Gemwarrior::VERSION

      0.upto(2) do |i|
        if remote_release.split('.')[i].to_i > local_release.split('.')[i].to_i
          new_release_available = true
        end
      end

      if new_release_available
        puts "GW v#{remote_release} available! Please exit and run 'gem update' before continuing."
        puts
      else
        puts 'You have the latest version. Fantastic!'
        puts
      end
    end

    def print_options_sound_sytem
      puts
      puts 'Sound System Selection'.colorize(:yellow)
      puts '================================='.colorize(:yellow)
      puts
      win32 = ' (1) WIN32-SOUND '
      OS.windows? ? (print win32) : (print win32.colorize(:light_black))
      print '(SELECTED)'.colorize(:yellow) if GameOptions.data['sound_system'].eql?('win32-sound')
      print "\n"
      print ' (2) FEEP        '
      print '(SELECTED)'.colorize(:yellow) if GameOptions.data['sound_system'].eql?('feep')
      print "\n"
      print ' (3) BLOOPS      '
      print '(SELECTED)'.colorize(:yellow) if GameOptions.data['sound_system'].eql?('bloops')
      print "\n"
      print "\n"
      print ' (T) TEST SOUND  '
      print "\n"
      puts
      puts ' WIN32-SOUND : good quality; Windows-only'
      puts ' FEEP        : cross-platform; VERY SLOW and BUGGY'
      puts ' BLOOPS      : cross-platform; requires portaudio'
      puts
      puts ' NOTE: none of these are required dependencies anymore, as sound is optional.'
      puts ' If you do not have the one selected installed on your machine, you will get '
      puts ' an error on game load, and no sound will be heard.'
      puts
      puts '================================='.colorize(:yellow)
      puts
      puts 'Enter option number to select sound system, or any other key to exit.'
      puts
      print '[GW_OPTS]-[SOUND_SYSTEM]> '

      answer = STDIN.getch.chomp.downcase

      case answer
      when '1'
        if OS.windows?
          puts answer
          GameOptions.add 'sound_system', 'win32-sound'
          Audio.init
        else
          puts answer
          puts "Sorry, but your system doesn't seem to be running Windows."
        end
        print_options_sound_sytem
      when '2'
        puts answer
        GameOptions.add 'sound_system', 'feep'
        Audio.init
        print_options_sound_sytem
      when '3'
        puts answer
        GameOptions.add 'sound_system', 'bloops'
        Audio.init
        print_options_sound_sytem
      when 't'
        puts answer
        Audio.init
        play_test_tune
        print_errors
        print_options_sound_sytem
      else
        puts
        return
      end
    end

    def print_options
      puts
      puts 'Gem Warrior General Options'.colorize(:yellow)
      puts '================================='.colorize(:yellow)
      puts
      puts 'Change several sound options, whether Wordnik is used to generate more dynamic descriptors of entities (valid WORDNIK_API_KEY environment variable must be set), and if attack/fight commands need to have a target or not (if enabled, will attack first monster in vicinty).'
      puts
      puts " (1) SOUND ENABLED    : #{GameOptions.data['sound_enabled']}"
      puts " (2) SOUND SYSTEM     : #{GameOptions.data['sound_system']}"
      puts " (3) SOUND VOLUME     : #{GameOptions.data['sound_volume']}"
      puts " (4) USE WORDNIK      : #{GameOptions.data['use_wordnik']}"
      puts " (5) FIGHT COMPLETION : #{GameOptions.data['fight_completion']}"
      puts
      puts '================================='.colorize(:yellow)
      puts
      puts 'Enter option number to change value, or any other key to return to main menu.'
      puts
      print '[GW_OPTS]> '

      answer = STDIN.getch

      case answer
      when '1'
        print answer
        GameOptions.data['sound_enabled'] = !GameOptions.data['sound_enabled']
        if GameOptions.data['sound_enabled']
          Audio.init
        end
        print_options
      when '2'
        print answer
        print "\n"
        print_options_sound_sytem
        print_options
      when '3'
        print answer
        print "\n"
        print 'Enter a volume from 0.0 to 1.0: '
        new_vol = gets.chomp.to_f.abs
        if new_vol >= 0.0 and new_vol <= 1.0
          GameOptions.data['sound_volume'] = new_vol
        else
          puts 'Not a valid volume.'
        end
        print_options
      when '4'
        print answer
        GameOptions.data['use_wordnik'] = !GameOptions.data['use_wordnik']
        print_options
      when '5'
        print answer
        GameOptions.data['fight_completion'] = !GameOptions.data['fight_completion']
        print_options
      else
        print answer
        return
      end
    end

    def print_sound_test
      puts
      puts 'Gem Warrior Sound Test'.colorize(:yellow)
      puts '================================='.colorize(:yellow)

      if GameOptions.data['sound_enabled']
        puts
        puts 'Play all the sounds in Gemwarrior.'
        puts

        cues = Audio.get_cues
        for cue in cues do
          pp cue[0].to_s
        end

        puts
        puts '================================='.colorize(:yellow)
        puts
        puts 'Enter sound id to play it, or enter "x" to return to the main menu.'
      else
        GameOptions.data['errors'] = ERROR_SOUND_NOT_ENABLED
      end

      print_errors

      puts
      print '[GW_SOUND_TEST]> '

      answer = gets.chomp.downcase

      # print answer
      if answer.eql?('x')
        return
      else
        Audio.play_synth(answer.to_sym)
        print_sound_test
      end
    end

    def print_main_menu
      puts
      puts "      GW v#{Gemwarrior::VERSION}"
      puts '======================='

      save_file = get_save_file_name
      if not save_file.nil?
        recent_name = save_file.instance_variable_get(:@player).name
        puts " #{'(R)esume Game'.colorize(:green)} as #{recent_name.colorize(:yellow)}"
      end

      puts ' (N)ew Game'
      puts ' (A)bout'
      puts ' (H)elp'
      puts ' (O)ptions'
      puts ' (L)og of Attempts'
      puts ' (S)ound Test'
      puts ' (C)heck for Updates'
      puts ' (E)xit'.colorize(:red)
      puts '======================='
      puts
    end

    def print_main_menu_prompt
      print '> '
    end

    def run_main_menu(show_choices = true)
      print_main_menu if show_choices
      print_main_menu_prompt if show_choices

      choice = STDIN.getch.downcase

      case choice
      when 'n'
        if overwrite_save?
          clear_screen
          play_intro_tune
          print_splash_message
          print_fortune
          return
        else
          run_main_menu
        end
      when 'r'
        if save_file_exist?
          result = resume_game
          if result.nil?
            run_main_menu
          else
            print_errors
            play_resume_tune
            load_saved_world(result)
            return
          end
        end
      when 'a'
        puts choice
        print_about_text
        run_main_menu
      when 'h'
        puts choice
        print_help_text
        run_main_menu
      when 'o'
        puts choice
        print_options
        run_main_menu
      when 'l'
        puts choice
        display_log_of_attempts
        run_main_menu
      when 's'
        puts choice
        print_sound_test
        run_main_menu
      when 'c'
        puts choice
        check_for_new_release
        run_main_menu
      when 'e', 'x', 'q'
        puts choice
        puts MAIN_MENU_QUIT_MESSAGE
        game.update_options_file
        exit
      when "\c?"  # Backspace/Delete
        refresh_menu
      when "\e"   # ANSI escape sequence
        case STDIN.getch
        when '['  # CSI
          choice = STDIN.getch
          puts choice
          case choice
          when 'A', 'B', 'C', 'D' # arrow keys
            refresh_menu
          end
        end
      else        # All other invalid options
        refresh_menu
      end
    end

    # need this to handle any non-valid input at the main menu
    def refresh_menu
      clear_screen
      print_logo
      run_main_menu
    end

    def log_stats(duration, pl)
      # display stats upon exit
      Hr.print('#')
      print 'Gem Warrior'.colorize(color: :white, background: :black)
      print " v#{Gemwarrior::VERSION}".colorize(:yellow)
      print " played for #{duration[:mins].to_s.colorize(color: :white, background: :black)} min(s)"
      print ", #{duration[:secs].to_s.colorize(color: :white, background: :black)} sec(s)"
      # print ", and #{duration[:ms].to_s.colorize(color: :white, background: :black)} ms"
      print "\n"
      Hr.print('-')
      print "#{pl.name.ljust(10).colorize(:green)} "
      print "destroyed #{pl.monsters_killed.to_s.colorize(color: :yellow, background: :black)} monster(s)"
      print "\n".ljust(12)
      print "destroyed #{pl.bosses_killed.to_s.colorize(color: :yellow, background: :black)} boss(es)"
      print "\n".ljust(12)
      print "picked up #{pl.items_taken.to_s.colorize(color: :yellow, background: :black)} item(s)"
      print "\n".ljust(12)
      print "traveled  #{pl.movements_made.to_s.colorize(color: :yellow, background: :black)} time(s)"
      print "\n".ljust(12)
      print "rested    #{pl.rests_taken.to_s.colorize(color: :yellow, background: :black)} time(s)"
      print "\n".ljust(12)
      print "died      #{pl.deaths.to_s.colorize(color: :yellow, background: :black)} time(s)"
      print "\n"
      Hr.print('#')

      # log stats to file in home directory
      File.open(GameOptions.data['log_file_path'], 'a') do |f|
        f.write "#{Time.now} #{pl.name.rjust(13)} - V:#{Gemwarrior::VERSION} LV:#{pl.level} XP:#{pl.xp} $:#{pl.rox} MK:#{pl.monsters_killed} BK:#{pl.bosses_killed} ITM:#{pl.items_taken} MOV:#{pl.movements_made} RST:#{pl.rests_taken} DTH:#{pl.deaths}\n"
      end
    end

    def save_game(world)
      mode = GameOptions.data['save_file_mode']
      puts 'Saving game...'

      if mode.eql? 'Y'
        File.open(GameOptions.data['save_file_yaml_path'], 'w') do |f|
          f.write YAML.dump(world)
        end
      elsif mode.eql? 'M'
        File.open(GameOptions.data['save_file_bin_path'], 'w') do |f|
          f.write Marshal.dump(world)
        end
      else
        puts 'Error: Save file mode not set. Game not saved.'
        return
      end
      puts 'Game saved!'
    end

    def save_file_exist?
      mode = GameOptions.data['save_file_mode']
      if mode.eql? 'Y'
        File.exist?(GameOptions.data['save_file_yaml_path'])
      elsif mode.eql? 'M'
        File.exist?(GameOptions.data['save_file_bin_path'])
      else
        false
      end
    end

    def resume_game
      mode = GameOptions.data['save_file_mode']
      puts 'Resuming game...'

      if mode.eql? 'Y'
        if File.exist?(GameOptions.data['save_file_yaml_path'])
          File.open(GameOptions.data['save_file_yaml_path'], 'r') do |f|
            return YAML.unsafe_load(f)
          end
        else
          puts 'No save file exists.'
          nil
        end
      elsif mode.eql? 'M'
        if File.exist?(GameOptions.data['save_file_marshal_path'])
          File.open(GameOptions.data['save_file_marshal_path'], 'r') do |f|
            return Marshal.load(f)
          end
        else
          puts 'No save file exists.'
          nil
        end
      end
    end

    def overwrite_save?
      mode = GameOptions.data['save_file_mode']
      save_file_path = ''

      if mode.eql? 'Y'
        save_file_path = GameOptions.data['save_file_yaml_path']
      elsif mode.eql? 'M'
        save_file_path = GameOptions.data['save_file_marshal_path']
      end

      if File.exist?(save_file_path)
        print 'Overwrite existing save file? (y/n) '
        answer = gets.chomp.downcase

        case answer
        when 'y', 'yes'
          puts 'New game started! Press any key to continue.'
          gets
          return true
        else
          puts 'New game aborted.'
          return false
        end
      end
      true
    end

    def update_duration(new_duration)
      new_mins = new_duration[:mins]
      new_secs = new_duration[:secs]
      new_ms   = new_duration[:ms]

      world.duration[:mins] += new_mins
      world.duration[:secs] += new_secs
      world.duration[:ms]   += new_ms

      if world.duration[:ms] > 1000
        world.duration[:secs] += world.duration[:ms] / 1000
        world.duration[:ms] = world.duration[:ms] % 1000
      end

      if world.duration[:secs] > 60
        world.duration[:mins] += world.duration[:secs] / 60
        world.duration[:secs] = world.duration[:secs] % 60
      end
    end

    def load_saved_world(result)
      self.world = result
      self.evaluator = Evaluator.new(self.world)
    end

    def setup_screen(initial_command = nil, extra_command = nil, new_skip = false, resume_skip = false)
      # welcome player to game
      clear_screen
      print_logo

      # main menu loop until new game or exit
      if new_skip
        print_errors
        play_intro_tune
        print_splash_message
        print_fortune
      elsif resume_skip
        result = resume_game
        if result.nil?
          run_main_menu
        else
          print_errors
          load_saved_world(result)
        end
      else
        run_main_menu
      end

      # hook to do something right off the bat
      puts evaluator.parse(initial_command) unless initial_command.nil?
      puts evaluator.parse(extra_command) unless extra_command.nil?
    end

    def print_errors
      if GameOptions.data['errors']
        puts "\n\n"
        puts "Errors: #{GameOptions.data['errors'].colorize(:red)}"
        GameOptions.data['errors'] = nil
      end
    end

    def play_intro_tune
      Audio.play_synth(:intro)
    end

    def play_resume_tune
      Audio.play_synth(:resume_game)
    end

    def play_test_tune
      Audio.play_synth(:test)
    end

    def prompt
      prompt_template =  "\n"
      prompt_template += "[LV:%2s][XP:%3s][ROX:%3s][HP:%3s/%-3s] [".colorize(:yellow)
      prompt_template += "%s".colorize(:green)
      prompt_template += " @ ".colorize(:yellow)
      prompt_template += "%s".colorize(:cyan)
      prompt_template += "]".colorize(:yellow)
      prompt_template += "[%s, %s, %s]".colorize(:yellow) if GameOptions.data['debug_mode']
      prompt_template += "\n"
      prompt_template += '[c:character][i:inventory][l:look][u:use][t:take]'

      prompt_vars_arr = [
        world.player.level,
        world.player.xp,
        world.player.rox,
        world.player.hp_cur,
        world.player.hp_max,
        world.player.name,
        world.location_by_coords(world.player.cur_coords).name_display
      ]
      if GameOptions.data['debug_mode']
        prompt_vars_arr.push(world.player.cur_coords[:x], world.player.cur_coords[:y], world.player.cur_coords[:z])
      end
      print (prompt_template % prompt_vars_arr)
      print "\n"
    end

    def command_exists?(cmd)
      ENV['PATH'].split(File::PATH_SEPARATOR).collect { |d|
        Dir.entries d if Dir.exist? d
      }.flatten.include?(cmd)
    end
  end
end
