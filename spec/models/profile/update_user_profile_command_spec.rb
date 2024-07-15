require 'rails_helper'

RSpec.describe Profile::UpdateUserProfileCommand do
  describe '.call' do
    subject(:update_profile) { described_class.call(user_id:, full_name:, username:) }

    let(:user_id) { 1 }
    let(:full_name) { 'John Doe' }
    let(:username) { 'john_doe' }

    context 'when user exists' do
      let!(:current_user) { create(:user, id: user_id, full_name: 'Jane Doe', username: 'jane_doe') }

      it 'updates user full_name' do
        update_profile

        expect { current_user.reload }.to change(current_user, :full_name).from('Jane Doe').to('John Doe')
      end

      it 'updates user username' do
        update_profile

        expect { current_user.reload }.to change(current_user, :username).from('jane_doe').to('john_doe')
      end

      it 'returns success result with updated user' do
        update_profile => Result::Success(type: :updated, value: {user:})

        expect(current_user.reload).to eq(user)
      end
    end

    context 'when user does not exist' do
      it 'returns failure result with not found error' do
        update_profile => Result::Failure(type: :not_found, value: {errors:})

        expect(errors).to match([/Couldn't find User/])
      end
    end

    context 'when full name is invalid' do
      before { create(:user, id: user_id, full_name: 'Jane Doe', username: 'jane_doe') }

      let(:full_name) { '' }

      it 'returns failure result with invalid record error' do
        update_profile => Result::Failure(type: :invalid_record, value: {errors:})

        expect(errors).to match(["Full name can't be blank"])
      end
    end

    context 'when username is invalid' do
      before { create(:user, id: user_id, full_name: 'Jane Doe', username: 'jane_doe') }

      let(:username) { '' }

      it 'returns failure result with invalid record error' do
        update_profile => Result::Failure(type: :invalid_record, value: {errors:})

        expect(errors).to match(["Username can't be blank"])
      end
    end
  end
end
