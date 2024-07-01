require 'rails_helper'

RSpec.describe Reactions::CreateReactionCommand do
  describe '.call' do
    subject(:create_reaction) { described_class.call(kind:, user_id:, post_id:) }

    context 'when the reaction, user and post are valid' do
      let(:kind) { 'like' }
      let(:user_id) { create(:user).id }
      let(:post_id) { create(:post).id }

      it 'creates a reaction' do
        expect { create_reaction }.to change(Reaction, :count).by(1)
      end

      it 'returns a success result' do
        expect(create_reaction).to be_a(Result::Success)
      end

      it 'returns the created status' do
        create_reaction => { type: }

        expect(type).to eq(:created)
      end

      it 'returns the created reaction' do
        create_reaction => { reaction: }

        expect(reaction).to be_a(Reaction)
      end
    end

    context 'when the reaction is invalid' do
      let(:kind) { 'foo' }
      let(:user_id) { create(:user).id }
      let(:post_id) { create(:post).id }

      it 'does not create a reaction' do
        expect { create_reaction }.not_to change(Reaction, :count)
      end

      it 'returns a failure result' do
        expect(create_reaction).to be_a(Result::Failure)
      end

      it 'returns the invalid_record status' do
        create_reaction => { type: }

        expect(type).to eq(:invalid_record)
      end

      it 'returns the errors' do
        create_reaction => { errors: }

        expect(errors).to include("'foo' is not a valid kind")
      end
    end

    context 'when the user is invalid' do
      let(:kind) { 'like' }
      let(:user_id) { 0 }
      let(:post_id) { create(:post).id }

      it 'does not create a reaction' do
        expect { create_reaction }.not_to change(Reaction, :count)
      end

      it 'returns a failure result' do
        expect(create_reaction).to be_a(Result::Failure)
      end

      it 'returns the invalid_record status' do
        create_reaction => { type: }

        expect(type).to eq(:invalid_record)
      end

      it 'returns the errors' do
        create_reaction => { errors: }

        expect(errors).to include('User must exist')
      end
    end

    context 'when the post is invalid' do
      let(:kind) { 'like' }
      let(:user_id) { create(:user).id }
      let(:post_id) { 0 }

      it 'does not create a reaction' do
        expect { create_reaction }.not_to change(Reaction, :count)
      end

      it 'returns a failure result' do
        expect(create_reaction).to be_a(Result::Failure)
      end

      it 'returns the invalid_record status' do
        create_reaction => { type: }

        expect(type).to eq(:invalid_record)
      end

      it 'returns the errors' do
        create_reaction => { errors: }

        expect(errors).to include('Post must exist')
      end
    end
  end
end
