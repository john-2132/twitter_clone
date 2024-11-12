import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { currentUserId: Number }
  static targets = ["message", "text"]

  connect() {
    this.applyClasses()
  }

  applyClasses() {
    // 各ターゲット要素にクラスを適用
    this.messageTargets.forEach((message) => this.setMessageClasses(message, "message"))
    this.textTargets.forEach((text) => this.setMessageClasses(text, "text"))
  }

  setMessageClasses(element, type) {
    const isCurrentUser = parseInt(element.dataset.senderId) === this.currentUserIdValue
    const messageClasses = isCurrentUser
      ? ["row", "gx-0", "justify-content-end", "me-3", "my-1"]
      : ["row", "gx-0", "justify-content-start", isCurrentUser ? "me-3" : "ms-3", "my-1"]
      
    const textClasses = isCurrentUser
      ? ["bg-own", "rounded-pill", "px-3", "py-2", "w-fit-content", "mw-75"]
      : ["bg-other", "rounded-pill", "px-3", "py-2", "w-fit-content", "mw-75"]

    // タイプに応じてクラスを追加
    element.classList.add(...(type === "message" ? messageClasses : textClasses))
  }

  messageTargetConnected(element) {
    this.setMessageClasses(element, "message")
  }

  textTargetConnected(element) {
    this.setMessageClasses(element, "text")
  }
}
