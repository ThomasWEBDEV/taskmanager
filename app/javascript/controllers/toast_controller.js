import { Controller } from "@hotwired/stimulus"

// Contrôleur pour les toasts modernes auto-disparaissants
export default class extends Controller {
  static targets = ["progress"]

  connect() {
    // Auto-hide après 4 secondes
    this.hideTimer = setTimeout(() => {
      this.hide()
    }, 4000)

    // Démarrer la barre de progression
    if (this.hasProgressTarget) {
      this.progressTarget.style.animation = "progressBar 4s linear forwards"
    }
  }

  disconnect() {
    if (this.hideTimer) {
      clearTimeout(this.hideTimer)
    }
  }

  // Fermer manuellement
  close(event) {
    event.preventDefault()
    this.hide()
  }

  // Pause sur hover
  pause() {
    if (this.hideTimer) {
      clearTimeout(this.hideTimer)
    }
    if (this.hasProgressTarget) {
      this.progressTarget.style.animationPlayState = "paused"
    }
  }

  // Reprendre quand on quitte le hover
  resume() {
    const remainingTime = this.getRemainingTime()

    this.hideTimer = setTimeout(() => {
      this.hide()
    }, remainingTime)

    if (this.hasProgressTarget) {
      this.progressTarget.style.animationPlayState = "running"
    }
  }

  // Calculer le temps restant basé sur la barre de progression
  getRemainingTime() {
    if (!this.hasProgressTarget) return 1000

    const computedStyle = window.getComputedStyle(this.progressTarget)
    const width = parseFloat(computedStyle.width)
    const maxWidth = parseFloat(computedStyle.maxWidth) || 400
    const percentage = width / maxWidth

    return Math.max(percentage * 4000, 500) // Minimum 500ms
  }

  // Animation de disparition
  hide() {
    this.element.classList.add("hiding")

    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
