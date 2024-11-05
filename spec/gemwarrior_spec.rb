require 'spec_helper'
include Gemwarrior

describe Gemwarrior do
  let(:default_load_options) do
    GameOptions.add 'log_file_path', "#{Dir.home}/.gemwarrior_log"
    GameOptions.add 'options_file_path', "#{Dir.home}/.gemwarrior_options"

    Game.new(
      beast_mode:     false,
      debug_mode:     false,
      god_mode:       false,
      new_game:       false,
      sound_enabled:  false,
      sound_volume:   0.3,
      use_wordnik:    false,
      extra_command:  nil
    )
  end

  describe 'basic properties' do
    it 'has a version number' do
      expect(VERSION).not_to be nil
    end
    it 'display help menu' do
      skip 'not implemented yet' do
      end
    end
  end

  describe 'game load' do
    context 'default options' do
      it 'displays the main menu' do
        skip 'not implemented yet' do
        end
      end
    end
    context 'new game option enabled' do
      it 'displays the main game prompt and runs the look command' do
        skip 'not implemented yet' do
        end
      end
    end
  end
end
