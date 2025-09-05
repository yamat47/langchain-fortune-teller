import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button"]

  connect() {
    this.isSubmitting = false
  }

  submit(event) {
    if (this.isSubmitting) {
      event.preventDefault()
      return false
    }

    const inputValue = this.inputTarget.value.trim()
    if (!inputValue) {
      event.preventDefault()
      return false
    }

    this.isSubmitting = true
    this.buttonTarget.disabled = true
    this.inputTarget.disabled = true
    this.buttonTarget.textContent = "送信中..."
    
    // Add loading indicator to messages
    const messagesContainer = document.getElementById("messages")
    if (messagesContainer) {
      const userMessage = document.createElement("div")
      userMessage.className = "message user-message"
      userMessage.innerHTML = `
        <div class="message-content">
          <p>${this.escapeHtml(inputValue)}</p>
        </div>
      `
      
      const loadingMessage = document.createElement("div")
      loadingMessage.className = "message bot-message"
      loadingMessage.id = "temp-loading-indicator"
      loadingMessage.innerHTML = `
        <div class="message-content">
          <div class="typing-dots">
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
      `
      
      messagesContainer.appendChild(userMessage)
      messagesContainer.appendChild(loadingMessage)
      messagesContainer.scrollTop = messagesContainer.scrollHeight
    }

    // Clear input immediately for better UX
    this.inputTarget.value = ""
  }

  reset() {
    this.isSubmitting = false
    this.buttonTarget.disabled = false
    this.inputTarget.disabled = false
    this.buttonTarget.textContent = "送信"
    
    // Remove temporary loading indicator if it exists
    const tempLoading = document.getElementById("temp-loading-indicator")
    if (tempLoading) {
      tempLoading.remove()
    }
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}