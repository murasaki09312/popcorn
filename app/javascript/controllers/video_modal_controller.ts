import { Controller } from "@hotwired/stimulus"
import type { ActionEvent } from "@hotwired/stimulus"

type VideoModalParams = {
  url?: string
  title?: string
  tags?: string
  description?: string
}

export default class extends Controller {
  static targets = [
    "overlay",
    "dialog",
    "closeButton",
    "videoPlayer",
    "iframePlayer",
    "fallback",
    "fallbackLink",
    "title",
    "tags",
    "description"
  ]

  declare readonly overlayTarget: HTMLDivElement
  declare readonly dialogTarget: HTMLDivElement
  declare readonly closeButtonTarget: HTMLButtonElement
  declare readonly videoPlayerTarget: HTMLVideoElement
  declare readonly iframePlayerTarget: HTMLIFrameElement
  declare readonly fallbackTarget: HTMLDivElement
  declare readonly fallbackLinkTarget: HTMLAnchorElement
  declare readonly titleTarget: HTMLElement
  declare readonly tagsTarget: HTMLElement
  declare readonly descriptionTarget: HTMLElement

  #previouslyFocusedElement: HTMLElement | null = null
  #currentTrigger: HTMLElement | null = null

  open(event: ActionEvent) {
    const { url = "", title = "", tags = "", description = "" } = event.params as VideoModalParams
    const trigger = event.currentTarget

    this.#currentTrigger = trigger instanceof HTMLElement ? trigger : null
    this.#currentTrigger?.setAttribute("aria-expanded", "true")

    this.#previouslyFocusedElement = document.activeElement instanceof HTMLElement ? document.activeElement : null

    this.titleTarget.textContent = title
    this.tagsTarget.textContent = tags.length > 0 ? tags : "-"
    this.descriptionTarget.textContent = description.length > 0 ? description : "-"

    this.overlayTarget.classList.remove("hidden")
    this.overlayTarget.classList.add("flex")
    this.overlayTarget.setAttribute("aria-hidden", "false")
    document.body.classList.add("overflow-hidden")

    this.renderPlayer(url)
    this.dialogTarget.scrollTop = 0
    this.closeButtonTarget.focus()
  }

  close() {
    if (!this.isOpen()) {
      return
    }

    this.resetPlayer()
    this.overlayTarget.classList.add("hidden")
    this.overlayTarget.classList.remove("flex")
    this.overlayTarget.setAttribute("aria-hidden", "true")
    document.body.classList.remove("overflow-hidden")

    this.#currentTrigger?.setAttribute("aria-expanded", "false")
    this.#currentTrigger = null

    this.#previouslyFocusedElement?.focus()
    this.#previouslyFocusedElement = null
  }

  closeFromBackdrop(event: MouseEvent) {
    if (event.target === event.currentTarget) {
      this.close()
    }
  }

  closeWithKeyboard(event: KeyboardEvent) {
    if (event.key !== "Escape" || !this.isOpen()) {
      return
    }

    event.preventDefault()
    this.close()
  }

  stopPropagation(event: Event) {
    event.stopPropagation()
  }

  disconnect() {
    this.resetPlayer()
    this.#currentTrigger?.setAttribute("aria-expanded", "false")
    this.#currentTrigger = null
    this.#previouslyFocusedElement = null
    document.body.classList.remove("overflow-hidden")
  }

  private isOpen(): boolean {
    return !this.overlayTarget.classList.contains("hidden")
  }

  private renderPlayer(rawVideoUrl: string) {
    this.resetPlayer()

    const parsedUrl = this.parseHttpUrl(rawVideoUrl)
    if (!parsedUrl) {
      this.showFallback(null)
      return
    }

    const embedUrl = this.youtubeEmbedUrl(parsedUrl)
    if (embedUrl) {
      this.iframePlayerTarget.src = embedUrl
      this.iframePlayerTarget.classList.remove("hidden")
      return
    }

    if (this.directVideoUrl(parsedUrl)) {
      this.videoPlayerTarget.src = parsedUrl.toString()
      this.videoPlayerTarget.load()
      this.videoPlayerTarget.classList.remove("hidden")
      return
    }

    this.showFallback(parsedUrl)
  }

  private resetPlayer() {
    this.videoPlayerTarget.pause()
    this.videoPlayerTarget.removeAttribute("src")
    this.videoPlayerTarget.load()

    this.iframePlayerTarget.src = "about:blank"
    this.fallbackLinkTarget.href = "#"

    this.videoPlayerTarget.classList.add("hidden")
    this.iframePlayerTarget.classList.add("hidden")
    this.fallbackTarget.classList.add("hidden")
    this.fallbackTarget.classList.remove("flex")
    this.fallbackLinkTarget.classList.add("hidden")
  }

  private showFallback(url: URL | null) {
    this.fallbackTarget.classList.remove("hidden")
    this.fallbackTarget.classList.add("flex")

    if (url) {
      this.fallbackLinkTarget.href = url.toString()
      this.fallbackLinkTarget.classList.remove("hidden")
    }
  }

  private parseHttpUrl(rawUrl: string): URL | null {
    const normalized = rawUrl.trim()
    if (normalized.length === 0) {
      return null
    }

    try {
      const parsed = new URL(normalized)
      if (parsed.protocol === "http:" || parsed.protocol === "https:") {
        return parsed
      }

      return null
    } catch {
      return null
    }
  }

  private directVideoUrl(url: URL): boolean {
    const extensionAllowed = /\.(mp4|webm|ogg|mov|m4v)$/i.test(url.pathname)
    return url.host.length > 0 && extensionAllowed
  }

  private youtubeEmbedUrl(url: URL): string | null {
    const host = url.hostname.toLowerCase()

    if (host === "youtu.be") {
      const id = url.pathname.split("/").filter(Boolean)[0]
      return this.buildYouTubeEmbed(id)
    }

    if (!this.youtubeHost(host)) {
      return null
    }

    const watchId = url.searchParams.get("v")
    if (watchId) {
      return this.buildYouTubeEmbed(watchId)
    }

    const path = url.pathname.split("/").filter(Boolean)
    const marker = path[0]
    const id = path[1]

    if (id && marker && ["embed", "shorts", "live"].includes(marker)) {
      return this.buildYouTubeEmbed(id)
    }

    return null
  }

  private youtubeHost(hostname: string): boolean {
    return hostname === "youtube.com" || hostname.endsWith(".youtube.com")
  }

  private buildYouTubeEmbed(id: string | undefined): string | null {
    if (!id) {
      return null
    }

    const cleanId = id.replace(/[^a-zA-Z0-9_-]/g, "")
    if (cleanId.length === 0) {
      return null
    }

    return `https://www.youtube.com/embed/${cleanId}?rel=0`
  }
}
