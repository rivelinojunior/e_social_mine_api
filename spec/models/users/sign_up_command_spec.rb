# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SignUpCommand do
  describe '#call' do
    subject(:sign_up) { described_class.call(params:) }

    context 'with valid parameters' do
      let(:params) do
        {
          full_name: 'John Doe',
          username: 'johndoe',
          email: 'john.doe@example.com',
          password: 'securepassword',
          password_confirmation: 'securepassword'
        }
      end

      it 'creates a new User' do
        expect { sign_up }.to change(User, :count).by(1)
      end

      it 'returns a status of :created' do
        sign_up => {type:}

        expect(type).to eq(:created)
      end

      it 'includes user data in the response' do
        sign_up => {user:}

        expect(user).to have_attributes(
          'id' => be_present.and(be_a Integer),
          'full_name' => 'John Doe',
          'username' => 'johndoe',
          'email' => 'john.doe@example.com',
          'password_digest' => be_present.and(be_a String),
          'created_at' => be_present.and(be_a Time),
          'updated_at' => be_present.and(be_a Time)
        )
      end
    end

    context 'with invalid email' do
      let(:params) do
        {
          full_name: 'John Doe',
          username: 'johndoe',
          email: 'invalid-email',
          password: 'securepassword',
          password_confirmation: 'securepassword'
        }
      end

      it 'does not create a new User' do
        expect { sign_up }.not_to change(User, :count)
      end

      it 'returns a status of :invalid_record' do
        sign_up => {type:}

        expect(type).to eq(:invalid_record)
      end

      it 'includes errors in the response' do
        sign_up => {errors:}

        expect(errors).to include('Email is not an email')
      end
    end

    context 'with invalid password confirmation' do
      let(:params) do
        {
          full_name: 'John Doe',
          username: 'johndoe',
          email: 'john@gmail.com',
          password: 'securepassword',
          password_confirmation: 'wrong'
        }
      end

      it 'does not create a new User' do
        expect { sign_up }.not_to change(User, :count)
      end

      it 'returns a status of :invalid_record' do
        sign_up => {type:}

        expect(type).to eq(:invalid_record)
      end

      it 'includes errors in the response' do
        sign_up => {errors:}

        expect(errors).to include("Password confirmation doesn't match Password")
      end
    end

    context 'without username' do
      let(:params) do
        {
          full_name: 'John Doe',
          username: '',
          email: 'john@gmail.com',
          password: 'securepassword',
          password_confirmation: 'wrong'
        }
      end

      it 'does not create a new User' do
        expect { sign_up }.not_to change(User, :count)
      end

      it 'returns a status of :invalid_record' do
        sign_up => {type:}

        expect(type).to eq(:invalid_record)
      end

      it 'includes errors in the response' do
        sign_up => {errors:}

        expect(errors).to include("Username can't be blank")
      end
    end

    context 'without full_name' do
      let(:params) do
        {
          full_name: '',
          username: 'josndoe',
          email: 'john@gmail.com',
          password: 'securepassword',
          password_confirmation: 'wrong'
        }
      end

      it 'does not create a new User' do
        expect { sign_up }.not_to change(User, :count)
      end

      it 'returns a status of :invalid_record' do
        sign_up => {type:}

        expect(type).to eq(:invalid_record)
      end

      it 'includes errors in the response' do
        sign_up => {errors:}

        expect(errors).to include("Full name can't be blank")
      end
    end
  end
end
