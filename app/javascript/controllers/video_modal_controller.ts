import { Controller } from "@hotwired/stimulus"

type OpenParams = {
  url?: string
  title?: string
  tags?: string
  description?: string
}

type OpenEvent = Event & { params: OpenParams }

export default class extends Controller {
  static targets = [
    "overlay",
    "videoPlayer",
    "iframePlayer",
    "fallback",
    "fallbackLink",
    "title",
    "tags",
    "description"
  ]

  declare readonly overlayTarget: HTMLDivElement
  declare readonly videoPlayerTarget: HTMLVideoElement
  declare readonly iframePlayerTarget: HTMLIFrameElement
  declare readonly fallbackTarget: HTMLDivElement
  declare readonly fallbackLinkTarget: HTMLAnchorElement
  declare readonly titleTarget: HTMLElement
  declare readonly tagsTarget: HTMLElement
  declare readonly descriptionTarget: HTMLElement

  open(event: OpenEvent) {
    const { url = "", title = "", tags = "", description = "" } = event.params

    this.titleTarget.textContent = title
    this.tagsTarget.textContent = tags.length > 0 ? tags : "-"
    this.descriptionTarget.textContent = description.length > 0 ? description : "-"

    this.overlayTarget.classList.remove("hidden")
    this.overlayTarget.classList.add("flex")
    document.body.classList.add("overflow-hidden")

    this.renderPlayer(url)
  }

  close() {
    if (this.overlayTarget.classList.contains("hidden")) {
      return
    }

    this.resetPlayer()
    this.overlayTarget.classList.add("hidden")
    this.overlayTarget.classList.remove("flex")
    document.body.classList.remove("overflow-hidden")
  }

  closeFromBackdrop(event: MouseEvent) {
    if (event.target !== event.currentTarget) {
      return
    }

    this.close()
  }

  closeWithKeyboard(event: KeyboardEvent) {
    if (event.key !== "Escape") {
      return
    }

    this.close()
  }

  stopPropagation(event: Event) {
    event.stopPropagation()
  }

  disconnect() {
    this.resetPlayer()
    document.body.classList.remove("overflow-hidden")
  }

  private renderPlayer(videoUrl: string) {
    const normalizedUrl = videoUrl.trim()

    this.videoPlayerTarget.classList.add("hidden")
    this.iframePlayerTarget.classList.add("hidden")
    this.fallbackTarget.classList.add("hidden")
    this.fallbackTarget.classList.remove("flex")

    const embedUrl = this.youtubeEmbedUrl(normalizedUrl)
    if (embedUrl) {
      this.iframePlayerTarget.src = embedUrl
      this.iframePlayerTarget.classList.remove("hidden")
      return
    }

    if (this.directVideoUrl(normalizedUrl)) {
      this.videoPlayerTarget.src = normalizedUrl
      this.videoPlayerTarget.load()
      this.videoPlayerTarget.classList.remove("hidden")
      return
    }

    this.fallbackLinkTarget.href = normalizedUrl
    this.fallbackTarget.classList.remove("hidden")
    this.fallbackTarget.classList.add("flex")
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
  }

  private directVideoUrl(videoUrl: string): boolean {
    try {
      const url = new URL(videoUrl)
      const protocolAllowed = url.protocol === "http:" || url.protocol === "https:"
      const extensionAllowed = /\.(mp4|webm|ogg|mov|m4v)$/i.test(url.pathname)

      return protocolAllowed && extensionAllowed
    } catch {
      return false
    }
  }

  private youtubeEmbedUrl(videoUrl: string): string | null {
    try {
      const url = new URL(videoUrl)

      if (!["https:", "http:"].includes(url.protocol)) {
        return null
      }

      if (url.hostname === "youtu.be") {
        const id = url.pathname.split("/").filter(Boolean)[0]
        return id ? this.buildYouTubeEmbed(id) : null
      }

      if (url.hostname.endsWith("youtube.com")) {
        const watchId = url.searchParams.get("v")
        if (watchId) {
          return this.buildYouTubeEmbed(watchId)
        }

        const path = url.pathname.split("/").filter(Boolean)
        const marker = path[0]
        const id = path[1]

        if (id && ["embed", "shorts", "live"].includes(marker)) {
          return this.buildYouTubeEmbed(id)
        }
      }

      return null
    } catch {
      return null
    }
  }

  private buildYouTubeEmbed(id: string): string {
    const cleanId = id.replace(/[^a-zA-Z0-9_-]/g, "")
    return `https://www.youtube.com/embed/${cleanId}?rel=0`
  }
}
