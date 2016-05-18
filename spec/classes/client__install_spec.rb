require 'spec_helper'
describe 'rdiff_backup::client::install' do

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
            'remote_path' => '/srv/rdiff',
            'package'     => 'rdiff-backup',
            'rdiff_user'  => 'rdiffbackup',
            'rdiffbackuptag' => 'rdiffbackuptag',
            'rdiff_server' => 'backup.example.com',
          }
        }
        it { should contain_class('rdiff_backup::client::install') }
        it { should contain_package('rdiff-backup') }
        it { should contain_sshkeys__create_ssh_key('root').with(
          'ssh_keytype' => 'rsa'
        ) }
        it { expect(exported_resources).to contain_sshkeys__set_authorized_key('root@test.example.com to rdiffbackup@backup.example.com').with(
          'local_user' => 'rdiffbackup',
          'remote_user'  => 'root@test.example.com',
          'tag'    => 'rdiffbackuptag',
          'options' => 'command="rdiff-backup --server --restrict /srv/rdiff/test.example.com"',
        ) }
        it { expect(exported_resources).to contain_file('/srv/rdiff/test.example.com').with(
          'ensure' => 'directory',
          'owner'  => 'rdiffbackup',
          'tag'    => 'rdiffbackuptag',
        ) }
      end
    else
    end
    end
  end

end
