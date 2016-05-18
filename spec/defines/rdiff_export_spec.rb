require 'spec_helper'
describe 'rdiff_backup::rdiff_export',:type => :define do
  let(:title) { 'Test me' }
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
        context 'with good params' do
          let(:params) {
            {
              'ensure'          => 'present',
              'path'            => '/etc/httpd',
              'rdiff_retention' => '1D',
              'rdiff_user'      => 'rdiffbackup',
              'remote_path'     => '/srv/rdiff',
              'rdiff_server'    => 'backup.example.com',
              'backup_script'   => '/usr/local/bin/rdiff_backup.sh',
              'rdiffbackuptag'  => 'rdiffbackuptag',
            }
          }
          it { should compile }

        end
      else
      end
    end
  end
end
