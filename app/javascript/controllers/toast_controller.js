import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["progress"]
  
  connect() {
    // Configuration
    this.duration = 5000 // 5 secondes
    this.isPaused = false
    this.startTime = Date.now()
    this.remainingTime = this.duration
    
    // Démarrer l'auto-hide
    this.startTimer()
    
    // Animer la barre de progression
    if (this.hasProgressTarget) {
      this.progressTarget.style.transition = `transform ${this.duration}ms linear`
      this.progressTarget.style.transform = "scaleX(0)"
    }
  }
  
  disconnect() {
    this.clearTimer()
  }
  
  startTimer() {
    this.clearTimer()
    this.hideTimer = setTimeout(() => {
      this.hide()
    }, this.remainingTime)
  }
  
  clearTimer() {
    if (this.hideTimer) {
      clearTimeout(this.hideTimer)
      this.hideTimer = null
    }
  }
  
  pause() {
    if (!this.isPaused) {
      this.isPaused = true
      this.clearTimer()
      
      // Calculer le temps écoulé
      const elapsed = Date.now() - this.startTime
      this.remainingTime = Math.max(0, this.duration - elapsed)
      
      // Pauser la barre de progression
      if (this.hasProgressTarget) {
        const progress = (this.duration - this.remainingTime) / this.duration
        this.progressTarget.style.transition = "none"
        this.progressTarget.style.transform = `scaleX(${1 - progress})`
      }
    }
  }
  
  resume() {
    if (this.isPaused) {
      this.isPaused = false
      this.startTime = Date.now()
      this.startTimer()
      
      // Reprendre la barre de progression
      if (this.hasProgressTarget) {
        this.progressTarget.style.transition = `transform ${this.remainingTime}ms linear`
        this.progressTarget.style.transform = "scaleX(0)"
      }
    }
  }
  
  close(event) {
    if (event) {
      event.preventDefault()
    }
    this.hide()
  }
  
  hide() {
    this.clearTimer()
    
    // Animation de sortie
    this.element.classList.add("hiding")
    
    // Supprimer après l'animation
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
