require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションに関するテスト' do
    it '名前、メールアドレス、パスワードがある場合は有効' do
      valid_user = FactoryBot.build(:user)
      expect(valid_user).to be_valid
    end

    it '名前がない場合は無効' do
      user_without_name = FactoryBot.build(:user, name: '')
      expect(user_without_name).to be_invalid
    end

    it '名前が255文字を超える場合は無効' do
      user_more_than_name = FactoryBot.build(:user, name:
      'a' * 256)
      expect(user_more_than_name).to be_invalid
    end

    it 'メールアドレスがない場合は無効' do
      user_without_email = FactoryBot.build(:user, email: '')
      expect(user_without_email).to be_invalid
    end

    it  '重複したメールアドレスは無効' do
      user = FactoryBot.create(:user)
      user_duplicate_email = FactoryBot.build(:user, email: user.email)
      expect(user_duplicate_email).to be_invalid
    end

    it 'パスワードがない場合は無効' do
      user_without_password = FactoryBot.build(:user, password: '')
      expect(user_without_password).to be_invalid
    end

    it 'パスワード（確認用)とパスワードが一致しない場合は無効' do
      user_password_mismatch = FactoryBot.build(:user, password_confirmation: 'mismatch')
      expect(user_password_mismatch).to be_invalid
    end
  end

  describe '関連付けに関するテスト' do
    before do
      @user = FactoryBot.create(:user)
    end

    it 'bookmark_listsとの関連付け正しく設定されていること' do
      bookmark_list = FactoryBot.create(:bookmark_list, user: @user)
      expect(@user.bookmark_lists).to include bookmark_list
    end

    it 'reviewsとの関連付けが正しく設定されていること' do
      review = FactoryBot.create(:review, user: @user)
      expect(@user.reviews).to include review
    end
  end

  describe 'create_initial_listメソッドに関するテスト' do
    it 'ユーザーが作成された時に初期リストが作成されること' do
      user = FactoryBot.create(:user)
      expect(user.bookmark_lists.where(name: 'お気に入り')).to exist
    end
  end

  describe 'own?メソッドに関するテスト' do
    before do
      @user = FactoryBot.create(:user)
    end

    it 'ユーザーがオブジェクトの所有者である場合は、trueを返すこと' do
      review = FactoryBot.create(:review, user: @user)
      expect(@user.own?(review)).to eq(true)
    end

    it 'ユーザーがオブジェクトの所有者でない場合は、falseを返すこと' do
      another_user = FactoryBot.create(:user)
      review = FactoryBot.create(:review, user: another_user)
      expect(@user.own?(review)).to eq(false)
    end
  end
end
