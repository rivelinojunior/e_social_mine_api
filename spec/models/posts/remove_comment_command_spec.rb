# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Posts::RemoveCommentCommand do
  describe '.call' do
    subject(:remove_comment) { described_class.call(id:) }

    context 'when comment is found' do
      let!(:comment) { create(:comment) }
      let(:id) { comment.id }

      it 'removes a comment' do
        expect { remove_comment }.to change(Comment, :count).by(-1)
      end

      it 'returns a success result' do
        remove_comment => Result::Success(type:)

        expect(type).to eq(:ok)
      end
    end

    context 'when comment is not found' do
      let(:id) { 0 }

      it 'does not remove a comment' do
        expect { remove_comment }.not_to change(Comment, :count)
      end

      it 'returns the not_found status' do
        remove_comment => Result::Failure(type:)

        expect(type).to eq(:not_found)
      end

      it 'returns the errors' do
        remove_comment => Result::Failure(errors:)

        expect(errors).to include("Couldn't find Comment with 'id'=0")
      end
    end
  end
end
