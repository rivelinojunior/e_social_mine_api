# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reactions::RemoveReactionCommand do
  describe '.call' do
    subject(:remove_reaction) { described_class.call(id:) }

    context 'when reaction is found' do
      let!(:reaction) { create(:reaction) }
      let(:id) { reaction.id }

      it 'removes a reaction' do
        expect { remove_reaction }.to change(Reaction, :count).by(-1)
      end

      it 'returns a success result' do
        expect(remove_reaction).to be_a(Result::Success)
      end

      it 'returns the ok status' do
        remove_reaction => { type: }

        expect(type).to eq(:ok)
      end
    end

    context 'when reaction is not found' do
      let(:id) { 0 }

      it 'does not remove a reaction' do
        expect { remove_reaction }.not_to change(Reaction, :count)
      end

      it 'returns a failure result' do
        expect(remove_reaction).to be_a(Result::Failure)
      end

      it 'returns the not_found status' do
        remove_reaction => { type: }

        expect(type).to eq(:not_found)
      end

      it 'returns the errors' do
        remove_reaction => { errors: }

        expect(errors).to include("Couldn't find Reaction with 'id'=0")
      end
    end
  end
end
