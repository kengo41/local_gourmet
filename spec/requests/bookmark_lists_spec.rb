require 'rails_helper'

RSpec.describe "BookmarkLists", type: :request do
  let(:user) { create(:user) }
  let(:bookmark_list_1) { create(:bookmark_list, user: user ) }
  let(:bookmark_list_2) { build(:bookmark_list, user: user) }
  let(:shop) { create(:shop) }

  describe "GET /bookmark_lists" do
    it 'リスト一覧画面の表示に成功すること' do
      login(user)
      get bookmark_lists_path, params: { shop_id: shop.id }
      expect(response).to have_http_status(:success)
    end

    it 'ログインしていないとリスト一覧画面の表示に失敗すること' do
      get bookmark_lists_path
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'POST /bookmark_lists' do
    it 'リスト登録処理が正常に実行されること' do
      login(user)
      expect {
        post bookmark_lists_path, params: { bookmark_list: { name: bookmark_list_2.name, user: user } }
      }.to change(BookmarkList, :count).by(1)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /bookmark_list/:id' do
    it 'リスト詳細画面の表示に成功すること' do
      login(user)
      get bookmark_list_path(bookmark_list_1)
      expect(response).to have_http_status(:success)
    end

    it 'ログインしていないとリスト詳細画面の表示に失敗すること' do
      get bookmark_list_path(bookmark_list_1)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'GET /bookmark_list/:id/edit' do
    it 'リスト編集画面の表示に成功すること' do
      login(user)
      get edit_bookmark_list_path(bookmark_list_1)
      expect(response).to have_http_status(:success)
    end

    it 'ログインしていないとリスト編集画面の表示に失敗すること' do
      get edit_bookmark_list_path(bookmark_list_1)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'PATCH /bookmark_list/:id' do
    it 'リスト更新処理が正常に実行されること' do
      login(user)
      patch bookmark_list_path(bookmark_list_1), params: { bookmark_list: { name: 'リスト', user: user } }
      expect(response).to have_http_status(:success)
    end

    it 'リストが空欄の場合は更新処理に失敗すること' do
      login(user)
      patch bookmark_list_path(bookmark_list_1), params: { bookmark_list: { name: '', user: user } }
      expect(response.body).to include 'リスト名を入力してください'
    end
  end

  describe 'DELETE /bookmark_list/:id' do
    it 'リスト削除処理が正常に実行されること' do
      login(user)
      delete bookmark_list_path(bookmark_list_1)
      expect(response).to redirect_to my_page_path
    end
  end
end
