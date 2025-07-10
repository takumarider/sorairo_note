import { Application } from "@hotwired/stimulus"
import AdminCalendarController from "./admin_calendar_controller.js"
import CalendarController from "./calendar_controller.js"
import ReservationController from "./reservation.js"
import MenuFormController from "./menu_form_controller.js"

const application = Application.start()

application.register("admin-calendar", AdminCalendarController)
application.register("calendar", CalendarController)
application.register("reservation", ReservationController)
application.register("menu-form", MenuFormController)

export { application }
