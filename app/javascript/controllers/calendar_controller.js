import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slotInput"]

  connect() {
    console.log("Calendar controller connected")
    alert("Calendar controller connected!") // デバッグ用アラート
    this.selectedSlotInfo = document.getElementById('selected-slot-info')
    this.selectedSlotTime = document.getElementById('selected-slot-time')
    this.debugInfo = document.getElementById('debug-info')
    this.debugSlotId = document.getElementById('debug-slot-id')
    
    // 初期状態でデバッグ情報を表示（開発時のみ）
    if (this.debugInfo) {
      this.debugInfo.classList.remove('hidden')
      this.debugSlotId.textContent = '未選択'
    }
  }

  selectSlot(event) {
    event.preventDefault()
    event.stopPropagation()
    
    alert("Button clicked!") // デバッグ用アラート
    
    const slotId = event.currentTarget.dataset.slotId
    const button = event.currentTarget
    
    console.log("Button clicked:", button)
    console.log("Slot ID:", slotId)
    
    // 全ての選択可能なボタンから選択状態を解除
    const allButtons = this.element.querySelectorAll('.calendar-slot-btn')
    console.log("Found buttons:", allButtons.length)
    
    allButtons.forEach(btn => {
      if (!btn.disabled) {
        console.log("Resetting button:", btn)
        // インラインスタイルで確実にリセット
        btn.style.backgroundColor = '#dbeafe' // bg-sky-100
        btn.style.color = '#1d4ed8' // text-sky-700
        btn.style.border = 'none'
        btn.style.boxShadow = 'none'
        // クラスもリセット
        btn.classList.remove('bg-sky-500', 'text-white', 'ring-2', 'ring-sky-500', 'border-2', 'border-sky-500', 'shadow-lg')
        btn.classList.add('bg-sky-100', 'text-sky-700')
      }
    })
    
    // 選択されたボタンをハイライト
    console.log("Highlighting selected button:", button)
    // インラインスタイルで確実にハイライト
    button.style.backgroundColor = '#0ea5e9' // bg-sky-500
    button.style.color = '#ffffff' // text-white
    button.style.border = '2px solid #0ea5e9'
    button.style.boxShadow = '0 10px 15px -3px rgba(0, 0, 0, 0.1)'
    // クラスも追加
    button.classList.remove('bg-sky-100', 'text-sky-700')
    button.classList.add('bg-sky-500', 'text-white', 'ring-2', 'ring-sky-500', 'border-2', 'border-sky-500', 'shadow-lg')
    
    // hidden fieldにslot_idをセット
    if (this.hasSlotInputTarget) {
      this.slotInputTarget.value = slotId
      console.log("Set slot input value to:", slotId)
    }
    
    // デバッグ情報を表示
    if (this.debugInfo && this.debugSlotId) {
      this.debugSlotId.textContent = slotId
    }
    
    // 選択された時間枠の情報を表示
    this.showSelectedSlotInfo(button)
    
    console.log("Selection complete for slot:", slotId)
  }
  
  showSelectedSlotInfo(button) {
    if (this.selectedSlotInfo && this.selectedSlotTime) {
      const slotDate = button.dataset.slotDate
      const slotTime = button.dataset.slotTime
      this.selectedSlotTime.textContent = `${slotDate} ${slotTime}`
      this.selectedSlotInfo.classList.remove('hidden')
      console.log("Showing slot info:", `${slotDate} ${slotTime}`)
    }
  }
} 