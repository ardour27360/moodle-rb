require 'spec_helper'

describe Categories do
  let(:url) { ENV['MOODLE_URL'] || 'moodle.localhost' }
  let(:token) { ENV['MOODLE_TOKEN'] || '' }
  let(:category_moodle) { Moodle.new(token, url).categories }

  describe '#index', :vcr => {
    :match_requests_on => [:body, :headers], :record => :once
  } do
    let(:result) { category_moodle.index }

    specify do
      expect(result).to be_a Array
      expect(result.first).to have_key 'id'
    end
  end

  describe '#create', :vcr => {
    :match_requests_on => [:headers], :record => :once
  } do
    let(:params) do
      {
        :name => 'Test category'
      }
    end
    let(:result) { category_moodle.create(params) }

    specify do
      expect(result).to be_a Hash
      expect(result).to have_key 'id'
      expect(result).to have_key 'name'
    end
  end

  describe '#show', :vcr => {
    :match_requests_on => [:headers], :record => :once
  } do
    let(:id) { 6 }
    let(:result) { category_moodle.show(id) }

    specify do
      expect(result).to be_a Hash
      expect(result['id']).to eq 6
      expect(result['name']).to eq 'Test category'
    end
  end

  describe '#destroy', :vcr => {
    :match_requests_on => [:headers], :record => :once
  } do
    let(:id) { 6 }
    let(:result) { category_moodle.destroy(id) }

    specify do
      expect(result).to eq true
    end
  end
end