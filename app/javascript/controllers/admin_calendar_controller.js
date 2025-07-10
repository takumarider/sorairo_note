import { Controller } from "@hotwired/stimulus"
import { Calendar } from '@fullcalendar/core'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import interactionPlugin from '@fullcalendar/interaction'

export default class extends Controller {
  static targets = ["calendar", "modal", "form"]
  static values = { 
    slotsUrl: String,
    createUrl: String
  }

  connect() {
    console.log("AdminCalendar controller connected")
    this.initializeCalendar()
  }

  disconnect() {
    if (this.calendar) {
      this.calendar.destroy()
    }
  }

  initializeCalendar() {
    console.log("Initializing calendar...")
    
    const calendarEl = this.calendarTarget
    if (!calendarEl) {
      console.error("Calendar target not found")
      return
    }

    try {
      console.log("Creating FullCalendar instance...")
      
      this.calendar = new Calendar(calendarEl, {
        plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
        initialView: 'timeGridWeek',
        headerToolbar: {
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek,timeGridDay'
        },
        locale: 'ja',
        timeZone: 'Asia/Tokyo',
        slotMinTime: '09:00:00',
        slotMaxTime: '20:00:00',
        selectable: true,
        selectMirror: true,
        dayMaxEvents: true,
        weekends: true,
        events: this.slotsUrlValue || '/admin/slots.json',
        select: this.handleDateSelect.bind(this),
        eventClick: this.handleEventClick.bind(this),
        eventDrop: this.handleEventDrop.bind(this),
        eventResize: this.handleEventResize.bind(this)
      })

      this.calendar.render()
      console.log("FullCalendar rendered successfully")
    } catch (error) {
      console.error("Error initializing FullCalendar:", error)
      console.error("Error stack:", error.stack)
      this.showFallbackCalendar(calendarEl, error)
    }
  }

  showFallbackCalendar(calendarEl, error) {
    console.log("Showing fallback calendar")
    calendarEl.innerHTML = `
      <div style="padding: 20px; text-align: center; background: #f8f9fa; border-radius: 8px;">
        <h2>カレンダー表示エリア</h2>
        <p>FullCalendarの読み込みに失敗しました。</p>
        <p><strong>エラー詳細:</strong></p>
        <pre style="text-align: left; background: #f1f1f1; padding: 10px; border-radius: 4px; overflow-x: auto;">${error.message}</pre>
        <p><strong>現在の設定:</strong></p>
        <ul style="text-align: left; display: inline-block;">
          <li>jsbundling-rails + esbuild環境</li>
          <li>FullCalendar v6.1.18 (ESModules)</li>
        </ul>
        <br>
        <button onclick="alert('コントローラーは動作しています！')" style="padding: 8px 16px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;">
          テストボタン
        </button>
      </div>
    `
  }

  handleDateSelect(selectInfo) {
    console.log("Date selected:", selectInfo)
    const start = selectInfo.start
    const end = selectInfo.end
    
    // 営業時間外の選択を防ぐ
    if (start.getHours() < 9 || end.getHours() > 20) {
      alert('営業時間（9:00〜20:00）内で選択してください')
      this.calendar.unselect()
      return
    }

    // モーダルを開いて時間枠情報を設定
    this.openModal(start, end)
  }

  handleEventClick(clickInfo) {
    const event = clickInfo.event
    const slotId = event.id
    
    if (confirm('この時間枠を削除しますか？')) {
      this.deleteSlot(slotId)
    }
  }

  handleEventDrop(dropInfo) {
    const event = dropInfo.event
    const newStart = event.start
    const newEnd = event.end
    
    this.updateSlot(event.id, newStart, newEnd)
  }

  handleEventResize(resizeInfo) {
    const event = resizeInfo.event
    const newStart = event.start
    const newEnd = event.end
    
    this.updateSlot(event.id, newStart, newEnd)
  }

  openModal(start, end) {
    console.log("Opening modal for:", start, end)
    
    // フォームに時間情報を設定
    if (this.hasFormTarget) {
      const startTimeInput = this.formTarget.querySelector('[name="slot[start_time]"]')
      const endTimeInput = this.formTarget.querySelector('[name="slot[end_time]"]')
      
      if (startTimeInput && endTimeInput) {
        startTimeInput.value = this.formatDateTime(start)
        endTimeInput.value = this.formatDateTime(end)
      }
    }
    
    // モーダルを表示
    if (this.hasModalTarget) {
      this.modalTarget.classList.remove('hidden')
    }
  }

  closeModal() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.add('hidden')
    }
  }

  async createSlot(event) {
    event.preventDefault()
    
    if (!this.hasFormTarget) {
      console.error("Form target not found")
      return
    }
    
    const formData = new FormData(this.formTarget)
    
    try {
      const response = await fetch(this.createUrlValue || '/admin/slots', {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })
      
      if (response.ok) {
        this.closeModal()
        if (this.calendar) {
          this.calendar.refetchEvents()
        }
        alert('時間枠を作成しました')
      } else {
        const error = await response.json()
        alert('エラーが発生しました: ' + error.message)
      }
    } catch (error) {
      alert('エラーが発生しました: ' + error.message)
    }
  }

  async deleteSlot(slotId) {
    try {
      const response = await fetch(`/admin/slots/${slotId}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })
      
      if (response.ok) {
        if (this.calendar) {
          this.calendar.refetchEvents()
        }
        alert('時間枠を削除しました')
      } else {
        alert('削除に失敗しました')
      }
    } catch (error) {
      alert('エラーが発生しました: ' + error.message)
    }
  }

  async updateSlot(slotId, start, end) {
    const formData = new FormData()
    formData.append('slot[start_time]', this.formatDateTime(start))
    formData.append('slot[end_time]', this.formatDateTime(end))
    
    try {
      const response = await fetch(`/admin/slots/${slotId}`, {
        method: 'PATCH',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })
      
      if (response.ok) {
        if (this.calendar) {
          this.calendar.refetchEvents()
        }
      } else {
        alert('更新に失敗しました')
        if (this.calendar) {
          this.calendar.refetchEvents() // 元に戻す
        }
      }
    } catch (error) {
      alert('エラーが発生しました: ' + error.message)
      if (this.calendar) {
        this.calendar.refetchEvents() // 元に戻す
      }
    }
  }

  formatDateTime(date) {
    return date.toISOString().slice(0, 16).replace('T', ' ')
  }
} 