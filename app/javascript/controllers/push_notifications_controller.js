import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status"]

  connect() {
    this.checkNotificationPermission()
  }

  async checkNotificationPermission() {
    if (!('serviceWorker' in navigator) || !('PushManager' in window)) {
      this.updateStatus('Push notifications are not supported in this browser.')
      return
    }

    if (Notification.permission === 'granted') {
      this.updateStatus('Push notifications are enabled.')
      await this.subscribeToPush()
    } else if (Notification.permission === 'denied') {
      this.updateStatus('Push notifications are blocked. Please enable them in your browser settings.')
    } else {
      this.updateStatus('Click to enable push notifications.')
    }
  }

  async requestPermission() {
    try {
      const permission = await Notification.requestPermission()
      
      if (permission === 'granted') {
        this.updateStatus('Push notifications enabled!')
        await this.subscribeToPush()
      } else {
        this.updateStatus('Push notifications were denied.')
      }
    } catch (error) {
      this.updateStatus('Error requesting notification permission: ' + error.message)
    }
  }

  async subscribeToPush() {
    try {
      const registration = await navigator.serviceWorker.register('/service-worker.js')
      
      const subscription = await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: this.urlBase64ToUint8Array(this.getVapidPublicKey())
      })

      await this.saveSubscription(subscription)
      this.updateStatus('Successfully subscribed to push notifications!')
    } catch (error) {
      this.updateStatus('Error subscribing to push notifications: ' + error.message)
    }
  }

  async saveSubscription(subscription) {
    const response = await fetch('/api/v1/push_subscriptions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({
        subscription: {
          endpoint: subscription.endpoint,
          p256dh_key: this.arrayBufferToBase64(subscription.getKey('p256dh')),
          auth_key: this.arrayBufferToBase64(subscription.getKey('auth'))
        }
      })
    })

    if (!response.ok) {
      throw new Error('Failed to save subscription')
    }
  }

  urlBase64ToUint8Array(base64String) {
    const padding = '='.repeat((4 - base64String.length % 4) % 4)
    const base64 = (base64String + padding)
      .replace(/-/g, '+')
      .replace(/_/g, '/')

    const rawData = window.atob(base64)
    const outputArray = new Uint8Array(rawData.length)

    for (let i = 0; i < rawData.length; ++i) {
      outputArray[i] = rawData.charCodeAt(i)
    }
    return outputArray
  }

  arrayBufferToBase64(buffer) {
    const bytes = new Uint8Array(buffer)
    let binary = ''
    for (let i = 0; i < bytes.byteLength; i++) {
      binary += String.fromCharCode(bytes[i])
    }
    return window.btoa(binary)
  }

  getVapidPublicKey() {
    // This should be replaced with the actual VAPID public key from your Rails app
    return 'YOUR_VAPID_PUBLIC_KEY'
  }

  updateStatus(message) {
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = message
    }
  }
} 