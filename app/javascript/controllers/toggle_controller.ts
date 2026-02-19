import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  declare readonly messageTarget: HTMLElement
  #primary = true

  switch() {
    this.#primary = !this.#primary
    this.messageTarget.textContent = this.#primary ? "Turbo / Stimulus is ready." : "TypeScript controller is working."
  }
}
