require 'spec_helper'
describe 'rdiff_backup::server::import' do

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
            'rdiffbackuptag'  => 'rdiffbackuptag',
          }
        }
        it { should contain_class('rdiff_backup::server::import') }
        # We can't do any more tests since the rest of this class does
        # resource collection only and rspec can't test that :(
      end
    else
    end
    end
  end

end
