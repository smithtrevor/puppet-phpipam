require 'spec_helper'

describe 'phpipam' do
  context 'default with no parameters and supported osfamily' do
    let(:facts) {{
      :osfamily => 'RedHat',
      :operatingsystem => 'CentOS',
      :operatingsystemrelease => '7.0',
      :timezone => 'UTC',
      :concat_basedir => '/tmp',
      :path => '/bin'
    }}
    it 'should compile' do
      should compile
    end
  end
end
