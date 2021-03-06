#
# Unit tests for tuskar::db::mysql
#
require 'spec_helper'

describe 'tuskar::db::mysql' do

  let :pre_condition do
    [
      'include mysql::server',
      'include tuskar::db::sync'
    ]
  end

  let :params do
    { :dbname        => 'tuskar',
      :password      => 's3cr3t',
      :user          => 'tuskar',
      :charset       => 'utf8',
      :collate       => 'utf8_unicode_ci',
      :host          => '127.0.0.1',
    }
  end

  shared_examples_for 'tuskar mysql database' do

    context 'when omiting the required parameter password' do
      before { params.delete(:password) }
      it { expect { is_expected.to raise_error(Puppet::Error) } }
    end

    it 'creates a mysql database' do
      is_expected.to contain_openstacklib__db__mysql('tuskar').with(
        :user          => params[:user],
        :dbname        => params[:dbname],
        :password_hash => '*58C036CDA51D8E8BBBBF2F9EA5ABF111ADA444F0',
        :host          => params[:host],
        :charset       => params[:charset]
      )
    end

    context 'overriding allowed_hosts param to array' do
      before :each do
        params.merge!(
          :allowed_hosts  => ['127.0.0.1','%']
        )
      end

      it {
        is_expected.to contain_openstacklib__db__mysql('tuskar').with(
          :user          => params[:user],
          :dbname        => params[:dbname],
          :password_hash => '*58C036CDA51D8E8BBBBF2F9EA5ABF111ADA444F0',
          :host          => params[:host],
          :charset       => params[:charset],
          :allowed_hosts => ['127.0.0.1','%']
      )}
    end

    context 'overriding allowed_hosts param to string' do
      before :each do
        params.merge!(
          :allowed_hosts  => '192.168.1.1'
        )
      end

      it {
        is_expected.to contain_openstacklib__db__mysql('tuskar').with(
          :user          => params[:user],
          :dbname        => params[:dbname],
          :password_hash => '*58C036CDA51D8E8BBBBF2F9EA5ABF111ADA444F0',
          :host          => params[:host],
          :charset       => params[:charset],
          :allowed_hosts => '192.168.1.1'
      )}
    end

  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it_configures 'tuskar mysql database'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'tuskar mysql database'
  end
end
