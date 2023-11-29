# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        first_name: 'Example',
        last_name: 'User',
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      user.save
      expect(user).to be_valid
    end

    it 'is not valid when password and password_confirmation do not match' do
      user = User.new(
        first_name: 'Example',
        last_name: 'User',
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'different_password'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'is not valid without a password' do
      user = User.new(
        first_name: 'Example',
        last_name: 'User',
        email: 'user@example.com',
        password_confirmation: 'password'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Password can't be blank")
    end

    it 'is not valid without an email' do
      user = User.new(
        first_name: 'Example',
        last_name: 'User',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Email can't be blank")
    end

    it 'is not valid without a name' do
      user = User.new(
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("First name can't be blank")
    end

    it 'is not valid if email is not unique (case-insensitive)' do
      existing_user = User.create(
        first_name: 'Example',
        last_name: 'User',
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
      user = User.new(
        first_name: 'New',
        last_name: 'User',
        email: 'TEST@example.com', # Same email but different case
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Email has already been taken")
    end

    it 'is not valid if password length is less than the minimum required' do
      user = User.new(
        first_name: 'Example',
        last_name: 'User',
        email: 'user@example.com',
        password: 'short',
        password_confirmation: 'short'
      )
      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
    end

    describe '.authenticate_with_credentials' do
      it 'authenticates with correct email and password' do
        user = User.create(
          first_name: 'Example',
          last_name: 'User',
          email: 'user@example.com',
          password: 'password',
        )
        authenticated_user = User.authenticate_with_credentials('user@example.com', 'password')
        expect(authenticated_user).to eq(user)
      end
    
      it 'does not authenticate with incorrect password' do
        user = User.create(
          first_name: 'Example',
          last_name: 'User',
          email: 'user@example.com',
          password: 'password',
        )
        authenticated_user = User.authenticate_with_credentials('user@example.com', 'wrong_password')
        expect(authenticated_user).to be_nil
      end
    
      it 'does not authenticate with incorrect email' do
        user = User.create(
          first_name: 'Example',
          last_name: 'User',
          email: 'user@example.com',
          password: 'password',
        )
        authenticated_user = User.authenticate_with_credentials('wrong_user@example.com', 'password')
        expect(authenticated_user).to be_nil
      end
    
      it 'authenticates with email containing leading and trailing spaces' do
        user = User.create(
          first_name: 'Example',
          last_name: 'User',
          email: 'user@example.com',
          password: 'password',
        )
        authenticated_user = User.authenticate_with_credentials('  user@example.com  ', 'password')
        expect(authenticated_user).to eq(user)
      end
    
      it 'authenticates with email in different case' do
        user = User.create(
          first_name: 'Example',
          last_name: 'User',
          email: 'user@example.com',
          password: 'password',
        )
        authenticated_user = User.authenticate_with_credentials('UsEr@eXample.com', 'password')
        expect(authenticated_user).to eq(user)
      end
    end
  end
end
