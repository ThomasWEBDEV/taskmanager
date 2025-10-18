import { Controller } from "@hotwired/stimulus"

// Contrôleur pour recherche en temps réel avec debounce
export default class extends Controller {
  static targets = ["input", "results", "spinner", "count"]
  static values = { url: String }

  connect() {
    this.timeout = null
    this.lastQuery = ""
  }

  search(event) {
    const query = this.inputTarget.value.trim()
    
    // Ne pas rechercher si c'est la même requête
    if (query === this.lastQuery) return
    
    this.lastQuery = query
    
    // Annuler la recherche précédente
    clearTimeout(this.timeout)
    
    // Afficher le spinner
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.remove('d-none')
    }
    
    // Debounce de 300ms
    this.timeout = setTimeout(() => {
      this.performSearch(query)
    }, 300)
  }

  async performSearch(query) {
    const url = new URL(this.urlValue || window.location.href)
    
    if (query.length > 0) {
      url.searchParams.set('search', query)
    } else {
      url.searchParams.delete('search')
    }
    
    try {
      const response = await fetch(url, {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html, text/html',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      
      if (response.ok) {
        const html = await response.text()
        
        // Si c'est un Turbo Stream
        if (response.headers.get('content-type').includes('turbo-stream')) {
          Turbo.renderStreamMessage(html)
        } else {
          // Sinon, remplacer le contenu
          if (this.hasResultsTarget) {
            this.resultsTarget.innerHTML = html
          }
        }
        
        // Réinitialiser le drag & drop si nécessaire
        this.reinitializeSortable()
        
        // Animation de feedback
        this.animateResults()
      }
    } catch (error) {
      console.error('Erreur de recherche:', error)
    } finally {
      // Cacher le spinner
      if (this.hasSpinnerTarget) {
        this.spinnerTarget.classList.add('d-none')
      }
    }
  }

  clear() {
    this.inputTarget.value = ""
    this.lastQuery = ""
    this.performSearch("")
  }

  reinitializeSortable() {
    // Réinitialiser SortableJS après mise à jour du DOM
    const sortableElement = document.querySelector('[data-controller="sortable"]')
    if (sortableElement && window.Sortable) {
      const controller = this.application.getControllerForElementAndIdentifier(sortableElement, 'sortable')
      if (controller) {
        controller.disconnect()
        controller.connect()
      }
    }
  }

  animateResults() {
    if (this.hasResultsTarget) {
      this.resultsTarget.querySelectorAll('.fade-in-up').forEach((element, index) => {
        element.style.animationDelay = `${index * 0.05}s`
        element.classList.remove('fade-in-up')
        void element.offsetWidth // Force reflow
        element.classList.add('fade-in-up')
      })
    }
  }

  // Filtres rapides
  filterStatus(event) {
    const status = event.currentTarget.dataset.status
    const url = new URL(window.location.href)
    
    if (status) {
      url.searchParams.set('status', status)
    } else {
      url.searchParams.delete('status')
    }
    
    // Conserver la recherche actuelle
    if (this.inputTarget.value) {
      url.searchParams.set('search', this.inputTarget.value)
    }
    
    Turbo.visit(url.toString())
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
