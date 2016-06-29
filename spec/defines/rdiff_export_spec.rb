require 'spec_helper'
describe 'rdiff_backup::rdiff_export',:type => :define do
  let(:title) { 'test_me' }
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

          it { should contain_file('/usr/local/bin/rdiff_test_me_run.sh').with(
            'owner'   => 'root',
            'mode'    => '0700',
            'content' => '#!/bin/bash
(
    flock -x -n 200 || exit 0
    if [ "$1" != "--now" ]; then
        sleep $(( RANDOM %= 1 ))
    fi
    rdiff-backup --no-eas --include-symbolic-links --exclude-special-files   /etc/httpd rdiffbackup@backup.example.com::/srv/rdiff/test.example.com/test_me
    if [ $? == \'0\' ]; then
        rdiff-backup -v0 --force --remove-older-than 1Y2M3W4D5h6m7s rdiffbackup@backup.example.com::/srv/rdiff/test.example.com/test_me
    fi
) 200>/var/lock/rdiff_test_me_run.lock
',
            'tag'     => 'rdiffbackuptag',
          ) }

          it 'with includes and excludes as strings' do
            params.merge!({'exclude' => '/etc/httpd/not_this', 'include' => '/etc/httpd/not_this/but_this'})

          expect { should contain_file('/usr/local/bin/rdiff_test_me_run.sh').with(
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0700',
            'content' => '#!/bin/bash
(
    flock -x -n 200 || exit 0
    if [ "$1" != "--now" ]; then
        sleep $(( RANDOM %= 1 ))
    fi
    rdiff-backup --no-eas --include-symbolic-links --exclude-special-files  --include \'/etc/httpd/not_this/but_this\' --exclude \'/etc/httpd/not_this\'  /etc/httpd rdiffbackup@backup.example.com::/srv/rdiff/test.example.com/test_me
    if [ $? == \'0\' ]; then
        rdiff-backup -v0 --force --remove-older-than 1Y2M3W4D5h6m7s rdiffbackup@backup.example.com::/srv/rdiff/test.example.com/test_me
    fi
) 200>/var/lock/rdiff_test_me_run.lock
',)}
          end
          it 'with noeas, excludespecialfiles and includesymboliclinks as false' do
            params.merge!({'noeas' => false, 'excludespecialfiles' => false, 'includesymboliclinks' => false})

          expect { should contain_file('/usr/local/bin/rdiff_test_me_run.sh').with(
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0700',
            'content' => '#!/bin/bash
(
    flock -x -n 200 || exit 0
    if [ "$1" != "--now" ]; then
        sleep $(( RANDOM %= 1 ))
    fi
    rdiff-backup    /etc/httpd rdiffbackup@backup.example.com::/srv/rdiff/test.example.com/test_me
    if [ $? == \'0\' ]; then
        rdiff-backup -v0 --force --remove-older-than 1Y2M3W4D5h6m7s rdiffbackup@backup.example.com::/srv/rdiff/test.example.com/test_me
    fi
) 200>/var/lock/rdiff_test_me_run.lock
',)}
          end
          it 'with includes and excludes as arrays' do
            params.merge!({'exclude' => ['/etc/httpd/not_this'], 'include' => ['/etc/httpd/not_this/but_this']})

          expect { should contain_file('/usr/local/bin/rdiff_test_me_run.sh').with(
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0700',
            'content' => '#!/bin/bash
(
    flock -x -n 200 || exit 0
    if [ "$1" != "--now" ]; then
        sleep $(( RANDOM %= 14 ))
    fi
    rdiff-backup --no-eas --include-symbolic-links --exclude-special-files  --include \'/etc/httpd/not_this/but_this\' --exclude \'/etc/httpd/not_this\'  /etc/httpd rdiffbackup@backup.example.com::/srv/rdiff/test.example.com/test_me
    if [ $? == \'0\' ]; then
        rdiff-backup -v0 --force --remove-older-than 1Y2M3W4D5h6m7s rdiffbackup@backup.example.com::/srv/rdiff/test.example.com/test_me
    fi
) 200>/var/lock/rdiff_test_me_run.lock
',)}
          end
          it 'with includes and excludes as multi-element arrays' do
            params.merge!({'exclude' => ['/etc/httpd/not_this','/etc/httpd/not_this_either'], 'include' => ['/etc/httpd/not_this/but_this','/etc/httpd/not_this_either/but_this']})

          expect { should contain_file('/usr/local/bin/rdiff_test_me_run.sh').with(
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0700',
            'content' => '#!/bin/bash
(
    flock -x -n 200 || exit 0
    if [ "$1" != "--now" ]; then
        sleep $(( RANDOM %= 14 ))
    fi
    rdiff-backup --no-eas --include-symbolic-links --exclude-special-files  --include \'/etc/httpd/not_this/but_this\' \'/etc/httpd/not_this_either/but_this\' --exclude \'/etc/httpd/not_this\' \'/not_this_either\' /etc/httpd /srv/rdiff/test.example.com/test_me
    if [ $? == \'0\' ]; then
        rdiff-backup -v0 --force --remove-older-than 1Y2M3W4D5h6m7s /srv/rdiff/test.example.com/test_me
    fi
) 200>/var/lock/rdiff_test_me_run.lock
',)}
          end
          it  'with $rdiff_server == $::fqdn' do
            params.merge!({'rdiff_server' => 'test.example.com'})
          expect { should contain_file('/usr/local/bin/rdiff_test_me_run.sh').with(
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0700',
            'content' => '#!/bin/bash
(
    flock -x -n 200 || exit 0
    if [ "$1" != "--now" ]; then
        sleep $(( RANDOM %= 1 ))
    fi
    rdiff-backup --no-eas --include-symbolic-links --exclude-special-files   /etc/httpd /srv/rdiff/test.example.com/test_me
    if [ $? == \'0\' ]; then
        rdiff-backup -v0 --force --remove-older-than 1Y2M3W4D5h6m7s /srv/rdiff/test.example.com/test_me
    fi
) 200>/var/lock/rdiff_test_me_run.lock
',
            'tag'     => 'rdiffbackuptag',
          ) }
          end
          it { should contain_cron('test.example.com_test_me').with(
            'command' => '/usr/local/bin/rdiff_test_me_run.sh',
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
