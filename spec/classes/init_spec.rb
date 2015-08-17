require 'spec_helper'

describe 'phpipam' do
  context 'default with no parameters and supported osfamily' do
    let(:facts) {{
      :osfamily => 'RedHat',
      :operatingsystemrelease => '7.0',
      :concat_basedir => '/tmp',
      :path => '/bin'
    }}
    it 'should compile' do
      should compile
    end
  end
end
