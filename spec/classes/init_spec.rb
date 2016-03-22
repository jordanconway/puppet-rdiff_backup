require 'spec_helper'
describe 'rdiff_backup' do

  context 'with defaults for all parameters' do
    it { should contain_class('rdiff_backup') }
  end
end
