require 'spec_helper'
describe 'rdiff_backup::client::config::script' do

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
              'backup_script'     => '/usr/local/bin/rdiff_backup.sh',
            }
          }
          it { should contain_class('rdiff_backup::client::config::script') }
          it { should contain_concat('/usr/local/bin/rdiff_backup.sh').with(
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0700',
            'tag'     => 'rdiffbackuptag',
          ) }
          it { should contain_concat__fragment('backup_script_header').with(
            'target'   => '/usr/local/bin/rdiff_backup.sh',
            'content'   => "#!/bin/sh\n",
            'order'    => '01',
            'tag'     => 'rdiffbackuptag',
          ) }

        end
      else
      end
    end
  end
end
