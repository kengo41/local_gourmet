require 'rails_helper'

RSpec.describe BookmarkList, type: :model do
  let(:user) { FactoryBot.create(:user) }
  describe 'バリデーションに関するテスト' do
    it 'リスト名がある場合は有効' do
      bookmark_list = FactoryBot.build(:bookmark_list, user: user)
      expect(bookmark_list).to be_valid
    end

    it 'リスト名がない場合は無効' do
      bookmark_list_without_name = FactoryBot.build(:bookmark_list, name: '', user: user)
      expect(bookmark_list_without_name).to be_invalid
    end

    it 'リスト名が40文字を超える場合は無効' do
      bookmark_list_more_than_name = FactoryBot.build(:bookmark_list, name: 'a' * 41, user: user)
      expect(bookmark_list_more_than_name).to be_invalid
    end
  end

  describe '関連付けに関するテスト' do
    it 'bookmarksとの関連付けが正しく設定されていること' do
      bookmark_list = FactoryBot.create(:bookmark_list, user: user)
      shop = FactoryBot.create(:shop)
      bookmark_list.shops << shop
      expect(bookmark_list.shops).to include shop
    end
  end
end
