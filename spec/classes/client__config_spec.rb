require 'spec_helper'
describe 'rdiff_backup::client::config' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :fqdn            => 'test.example.com',
          :hostname        => 'test',
          :ipaddress       => '192.168.0.1',
        })
      end

    # we do not have default values so the class should fail compile
    context 'with defaults for all parameters' do
      let (:params) {{}}

      it do
        expect {
          should compile
        }.to raise_error(RSpec::Expectations::ExpectationNotMetError,
          /expects a value /)
      end
    end

    case facts[:osfamily]
    when 'RedHat'
      context 'with basic init defaults' do
        let(:params) {
          {
            'rdiffbackuptag' => 'rdiffbackuptag',
            'backup_script' => '/usr/local/bin/rdiff_backup.sh',
          }
        }
        it { should contain_class('rdiff_backup::client::config') }
        it { should contain_anchor('rdiff_backup::client::config::begin') }
        it { should contain_class('rdiff_backup::client::config::script') }
        it { should contain_anchor('rdiff_backup::client::config::end') }
      end
    else
    end
  end
  end
end
