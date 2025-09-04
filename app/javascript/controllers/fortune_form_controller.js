import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button"]

  connect() {
    this.isSubmitting = false
    this.checkButtonState()
    
    // Monitor input changes
    this.inputTarget.addEventListener('input', () => this.checkButtonState())
  }
  
  checkButtonState() {
    const isEmpty = this.inputTarget.value.trim() === ""
    this.buttonTarget.disabled = isEmpty || this.isSubmitting
    
    if (isEmpty && !this.isSubmitting) {
      this.buttonTarget.classList.add("disabled-empty")
    } else {
      this.buttonTarget.classList.remove("disabled-empty")
    }
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
    this.buttonTarget.textContent = "送信中..."
    
    // Add user message immediately
    const messagesContainer = document.getElementById("messages")
    if (messagesContainer) {
      const userMessage = document.createElement("div")
      userMessage.className = "message user-message"
      userMessage.innerHTML = `
        <div class="message-content">
          <p>${this.escapeHtml(inputValue)}</p>
        </div>
      `
      
      messagesContainer.appendChild(userMessage)
      
      // Add loading indicator
      const loadingMessage = document.createElement("div")
      loadingMessage.id = "temp-loading-indicator"
      loadingMessage.className = "message bot-message"
      loadingMessage.innerHTML = `
        <div class="message-content">
          <div class="typing-dots">
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
      `
      
      messagesContainer.appendChild(loadingMessage)
      messagesContainer.scrollTop = messagesContainer.scrollHeight
    }
  }

  reset() {
    this.isSubmitting = false
    this.inputTarget.disabled = false
    this.inputTarget.value = ""
    this.buttonTarget.textContent = "送信"
    
    // Remove temporary loading indicator if it exists
    const tempLoading = document.getElementById("temp-loading-indicator")
    if (tempLoading) {
      tempLoading.remove()
    }
    
    // Check button state after reset
    this.checkButtonState()
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
