require 'spec_helper'
describe 'rdiff_backup::client' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :fqdn            => 'test.example.com',
          :hostname        => 'test',
          :ipaddress       => '192.168.0.1',
        })
      end

      it { is_expected.to compile.with_all_deps }
      case facts[:osfamily]
      when 'RedHat'
        context 'with defaults for all parameters' do
          it { should contain_class('rdiff_backup::client') }
          it { should contain_anchor('rdiff_backup::client::begin') }
          it { should contain_class('rdiff_backup::client::install') }
          it { should contain_class('rdiff_backup::client::config') }
          it { should contain_anchor('rdiff_backup::client::end') }
        end
      else
      end
    end
  end

end
