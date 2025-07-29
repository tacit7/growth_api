# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has many events with dependent destroy' do
      reflection = described_class.reflect_on_association(:events)
      expect(reflection.macro).to eq(:has_many)
      expect(reflection.options[:dependent]).to eq(:destroy)
      expect(reflection.class_name).to eq('EventLog')
    end
  end

  describe 'validations' do
    it 'is invalid without a role' do
      user = build(:user, role: nil)
      expect(user).not_to be_valid
      expect(user.errors[:role]).to be_present
    end

    it 'is invalid without a subscription_type' do
      user = build(:user, subscription_type: nil)
      expect(user).not_to be_valid
      expect(user.errors[:subscription_type]).to be_present
    end
  end

  describe 'defaults' do
    it 'sets default role to user' do
      user = described_class.new
      expect(user.role).to eq('user')
    end

    it 'sets default subscription_type to free' do
      user = described_class.new
      expect(user.subscription_type).to eq('free')
    end
  end

  describe '#admin?' do
    it 'returns true when role is admin' do
      user = build(:user, role: :admin)
      expect(user.admin?).to be true
    end

    it 'returns false when role is user' do
      user = build(:user, role: :user)
      expect(user.admin?).to be false
    end
  end
end
