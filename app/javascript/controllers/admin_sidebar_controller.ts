import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "backdrop", "trigger"]

  private readonly desktopMediaQuery = window.matchMedia("(min-width: 768px)")

  declare readonly hasTriggerTarget: boolean
  declare readonly triggerTargets: HTMLButtonElement[]
  declare readonly sidebarTarget: HTMLElement
  declare readonly backdropTarget: HTMLElement

  connect() {
    this.desktopMediaQuery.addEventListener("change", this.handleViewportChange)
    this.syncLayout()
  }

  disconnect() {
    this.desktopMediaQuery.removeEventListener("change", this.handleViewportChange)
    document.body.classList.remove("overflow-hidden")
  }

  toggle() {
    if (this.isOpen()) {
      this.close()
      return
    }

    this.open()
  }

  open() {
    this.sidebarTarget.classList.remove("-translate-x-full")
    this.backdropTarget.classList.remove("hidden")
    this.sidebarTarget.setAttribute("aria-hidden", "false")
    this.updateExpandedState(true)
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.sidebarTarget.classList.add("-translate-x-full")
    this.backdropTarget.classList.add("hidden")
    this.sidebarTarget.setAttribute("aria-hidden", "true")
    this.updateExpandedState(false)
    document.body.classList.remove("overflow-hidden")
  }

  closeWithEscape(event: KeyboardEvent) {
    if (event.key !== "Escape" || !this.isOpen()) {
      return
    }

    this.close()
  }

  private readonly handleViewportChange = () => {
    this.syncLayout()
  }

  private syncLayout() {
    if (this.desktopMediaQuery.matches) {
      this.sidebarTarget.classList.remove("-translate-x-full")
      this.backdropTarget.classList.add("hidden")
      this.sidebarTarget.setAttribute("aria-hidden", "false")
      this.updateExpandedState(false)
      document.body.classList.remove("overflow-hidden")
      return
    }

    this.close()
  }

  private isOpen(): boolean {
    return !this.sidebarTarget.classList.contains("-translate-x-full")
  }

  private updateExpandedState(expanded: boolean) {
    if (!this.hasTriggerTarget) {
      return
    }

    this.triggerTargets.forEach((trigger) => {
      trigger.setAttribute("aria-expanded", expanded ? "true" : "false")
    })
  }
}
