import { Controller } from "@hotwired/stimulus"

shopId = null;

export default class extends Controller {
  static targets = ["myModal", "backGround"]

  connect() {
    // "bookmark-icon" クラスの要素を取得
    const bookmarkButtons = document.getElementsByClassName("bookmark-icon");

    // 各ブックマークボタンにクリックイベントリスナーを追加
    for (const bookmarkButton of bookmarkButtons) {
      bookmarkButton.addEventListener("click", this.buttonClick);
    }
  }

  open() {
    this.myModalTarget.classList.remove('hidden');
  }

  close(event) {
    const clickedList = event.currentTarget;
    const listId = clickedList.getAttribute("data-list-id");

    if (shopId && listId) {
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

      fetch(`/bookmarks?shop_id=${shopId}&list_id=${listId}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken, // CSRFトークンを追加
        },
      })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          throw new Error('サーバーエラー');
        }
      })
      .then(data => {
        if (data.success) {
          alert(`${data.name}に保存しました`);
        } else {
          alert('すでに保存しています');
        }
      })
      .catch(error => {
        console.error("リクエストエラー", error);
      });
    }
    this.backGroundTarget.classList.add("hidden");
  }

  closeModal() {
    this.backGroundTarget.classList.add("hidden");
  }

  buttonClick(event) {
    // クリックされたブックマークボタンから data-shop-id を取得
    const clickedButton = event.currentTarget;
    shopId = clickedButton.getAttribute("data-shop-id"); // グローバル変数に代入
  }

  closeBackground(event) {
    if(event.target === this.backGroundTarget) {
      this.closeModal();
    }
  }
}