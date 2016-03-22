require 'spec_helper'
describe 'rdiff_backup' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      case facts[:osfamily]
      when 'Debian'
        context 'with defaults for all parameters' do
          it { should contain_class('rdiff_backup') }
        end
      when 'RedHat'
        context 'with defaults for all parameters' do
          it { should contain_class('rdiff_backup') }
        end
      else
      end
    end
  end

end
