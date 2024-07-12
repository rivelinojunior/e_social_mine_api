# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments API V1' do
  describe 'POST /api/v1/comments' do
    subject(:perform_request) { post "/api/v1/posts/#{post_id}/comments", params:, as: :json, headers: }

    context 'when the user is authenticated' do
      let(:current_session) { create(:session) }
      let(:post_id) { create(:post, user: current_session.user).id }

      let(:headers) do
        {
          'Authorization' => "Bearer #{current_session.token}"
        }
      end

      context 'with valid params' do
        let(:params) do
          {
            message: 'Hello, world!'
          }
        end

        it 'returns a 201 status code' do
          perform_request

          expect(response).to have_http_status(:created)
        end

        it 'returns the created comment' do
          perform_request

          comment = Comment.last

          expect(response.parsed_body).to eq(
            'id' => comment.id,
            'message' => 'Hello, world!',
            'user_id' => current_session.user_id,
            'post_id' => post_id,
            'user' => { 'full_name' => current_session.user.full_name, 'username' => current_session.user.username },
            'created_at' => comment.created_at.iso8601(3)
          )
        end
      end

      context 'with invalid message' do
        let(:params) do
          {
            message: ''
          }
        end

        it 'returns a 422 status code' do
          perform_request

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          perform_request

          expect(response.parsed_body).to eq(
            'errors' => ["Message can't be blank"]
          )
        end
      end
    end

    context 'when the user is not authenticated' do
      let(:headers) { {} }
      let(:params) { {} }
      let(:post_id) { 0 }

      it 'returns a 401 status code' do
        perform_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/comments/:id' do
    subject(:perform_request) { delete "/api/v1/comments/#{comment_id}", headers: }

    context 'when the user is authenticated' do
      let(:current_session) { create(:session) }
      let!(:comment) { create(:comment, user: current_session.user) }
      let(:comment_id) { comment.id }

      let(:headers) do
        {
          'Authorization' => "Bearer #{current_session.token}"
        }
      end

      context 'when the comment exists' do
        it 'returns a 204 status code' do
          perform_request

          expect(response).to have_http_status(:no_content)
        end

        it 'removes the comment' do
          expect { perform_request }.to change(Comment, :count).by(-1)
        end
      end

      context 'when the comment does not exist' do
        let(:comment_id) { 0 }

        it 'returns a 404 status code' do
          perform_request

          expect(response).to have_http_status(:not_found)
        end

        it 'does not remove any comment' do
          expect { perform_request }.not_to change(Comment, :count)
        end
      end
    end

    context 'when the user is not authenticated' do
      let(:headers) { {} }
      let(:comment_id) { 0 }

      it 'returns a 401 status code' do
        perform_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
