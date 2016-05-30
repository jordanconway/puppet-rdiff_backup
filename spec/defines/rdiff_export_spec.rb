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
          /is not an absolute path. /)
      end
    end
      case facts[:osfamily]
      when 'RedHat'
        context 'with good params' do
          let(:params) {
            {
              'ensure'          => 'present',
              'path'            => '/etc/httpd',
              'rdiff_retention' => '1Y2M3W4D5h6m7s',
              'rdiff_user'      => 'rdiffbackup',
              'remote_path'     => '/srv/rdiff',
              'rdiff_server'    => 'backup.example.com',
              'rdiffbackuptag'  => 'rdiffbackuptag',
              'cron_hour'       => '2',
              'cron_minute'     => '15',
            }
          }
          it { should compile }

          it 'should fail on bad path' do
            params.merge!({'path' => 'not_a_path'})
            expect { should compile }.to \
              raise_error(RSpec::Expectations::ExpectationNotMetError,
                /is not an absolute path/)
          end

          it 'should fail on bad rdiff_retention' do
            params.merge!({'rdiff_retention' => 'Like, yesterday or something.'})
            expect { should compile }.to \
              raise_error(RSpec::Expectations::ExpectationNotMetError,
                /does not match/)
          end

          it 'should fail on bad rdiff_user' do
            params.merge!({'rdiff_user' => '-Bob!'})
            expect { should compile }.to \
              raise_error(RSpec::Expectations::ExpectationNotMetError,
                /does not match/)
          end

          it { should contain_concat('/usr/local/bin/rdiff_etc_httpd_run.sh').with(
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0700',
            'tag'     => 'rdiffbackuptag',
          ) }
          it { should contain_concat__fragment('backup_script_header_etc_httpd').with(
            'target'   => '/usr/local/bin/rdiff_etc_httpd_run.sh',
            'content'   => "#!/bin/sh\n",
            'order'    => '01',
            'tag'     => 'rdiffbackuptag',
          ) }

          it { should contain_concat__fragment('backup_etc_httpd').with(
            'content' => "rdiff-backup /etc/httpd rdiffbackup@backup.example.com::/srv/rdiff/test.example.com/etc_httpd\n\n",
            'order'    => '10',
          ) }

          it { should contain_concat__fragment('retention_etc_httpd').with(
            'content' => "rdiff-backup -v0 --force --remove-older-than 1Y2M3W4D5h6m7s rdiffbackup@backup.example.com::/srv/rdiff/test.example.com/etc_httpd\n\n",
            'order'    => '15',
          ) }

          it 'with $rdiff_server == $::fqdn' do
            params.merge!({'rdiff_server' => 'test.example.com'})

            expect { should contain_concat__fragment('backup_etc_httpd').with(
              'content' => "rdiff-backup /etc/httpd /srv/rdiff/test.example.com/etc_httpd\n\n",
              'order'    => '10',
            ) }

            expect { should contain_concat__fragment('retention_etc_httpd').with(
              'content' => "rdiff-backup -v0 --force --remove-older-than 1Y2M3W4D5h6m7s /srv/rdiff/test.example.com/etc_httpd\n\n",
              'order'    => '15',
            ) }
          end

          it { should contain_cron('test.example.com_etc_httpd').with(
            'command' => '/usr/local/bin/rdiff_etc_httpd_run.sh',
            'user'    => 'root',
            'hour'    => '2',
            'minute'  => '15',
          ) }

        end
      else
      end
    end
  end
end
