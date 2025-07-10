import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["formContainer", "toggleButton", "form"]

  connect() {
    console.log("MenuForm controller connected")
    console.log("Targets found:", {
      formContainer: this.hasFormContainerTarget,
      toggleButton: this.hasToggleButtonTarget,
      form: this.hasFormTarget
    })
    
    // Turbo Streamのレスポンスを監視
    document.addEventListener("turbo:stream-render", this.handleTurboStream.bind(this))
  }

  disconnect() {
    // イベントリスナーを削除
    document.removeEventListener("turbo:stream-render", this.handleTurboStream.bind(this))
  }

  toggleForm() {
    console.log("toggleForm method called")
    
    if (!this.hasFormContainerTarget || !this.hasToggleButtonTarget) {
      console.error("Required targets not found")
      return
    }
    
    const formContainer = this.formContainerTarget
    const toggleButton = this.toggleButtonTarget
    
    console.log("Current form classes:", formContainer.className)
    
    if (formContainer.classList.contains("hidden")) {
      // フォームを表示
      console.log("Showing form")
      formContainer.classList.remove("hidden")
      toggleButton.textContent = "− フォームを閉じる"
      toggleButton.classList.remove("btn-primary")
      toggleButton.classList.add("btn-secondary")
    } else {
      // フォームを非表示
      console.log("Hiding form")
      this.hideForm()
    }
  }

  hideForm() {
    console.log("hideForm method called")
    
    if (!this.hasFormContainerTarget || !this.hasToggleButtonTarget) {
      console.error("Required targets not found in hideForm")
      return
    }
    
    const formContainer = this.formContainerTarget
    const toggleButton = this.toggleButtonTarget
    
    formContainer.classList.add("hidden")
    toggleButton.textContent = "＋ 新規メニューを追加"
    toggleButton.classList.remove("btn-secondary")
    toggleButton.classList.add("btn-primary")
    
    // フォームをリセット
    if (this.hasFormTarget) {
      this.formTarget.reset()
    }
  }

  handleSubmit(event) {
    // Turbo Streamのレスポンスを待つ
    console.log("Form submitted, waiting for Turbo Stream response")
  }

  handleTurboStream(event) {
    // フラッシュメッセージが表示された場合、フォームを非表示にする
    const flashElement = document.getElementById("flash")
    if (flashElement && flashElement.innerHTML.trim() !== "") {
      // 成功メッセージが表示された場合
      if (flashElement.querySelector(".alert-success")) {
        this.hideForm()
      }
    }
  }
} 