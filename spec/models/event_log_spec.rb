# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventLog, type: :model do
  let(:valid_attributes) do
    {
      user_id: 1,
      event_type: 1,
      event_data: { referrer: 'google.com' },
      occurred_at: Time.current,
      ip_address: '127.0.0.1',
      user_agent: 'RSpec',
    }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(described_class.new(valid_attributes)).to be_valid
    end

    it 'is invalid without event_type' do
      expect(described_class.new(valid_attributes.except(:event_type))).not_to be_valid
    end

    it 'is invalid with unknown event_type' do
      log = described_class.new(valid_attributes.merge(event_type: 999))
      expect(log).not_to be_valid
    end

    it 'is invalid without occurred_at' do
      expect(described_class.new(valid_attributes.except(:occurred_at))).not_to be_valid
    end
  end

  describe '#event_name' do
    it 'returns the human name for the event_type' do
      log = described_class.new(valid_attributes.merge(event_type: 3))
      expect(log.event_name).to eq('Signup')
    end
  end
end
