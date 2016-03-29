require 'spec_helper'
describe 'rdiff_backup::server::init' do

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
      when 'Debian'
        context 'with defaults for all parameters' do
          it { should contain_class('rdiff_backup::server::init') }
          it { should contain_anchor('rdiff_backup::server::begin') }
          it { should contain_class('rdiff_backup::server::install') }
          it { should contain_anchor('rdiff_backup::server::end') }
        end
      when 'RedHat'
        context 'with defaults for all parameters' do
          it { should contain_class('rdiff_backup::server::init') }
          it { should contain_anchor('rdiff_backup::server::begin') }
          it { should contain_class('rdiff_backup::server::install') }
          it { should contain_anchor('rdiff_backup::server::end') }
        end
      else
      end
    end
  end

end
