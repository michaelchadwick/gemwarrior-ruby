require 'spec_helper'
include Gemwarrior

  describe 'basic properties' do
    it 'has a version number' do
      expect(VERSION).not_to be nil
    end
  end
  
