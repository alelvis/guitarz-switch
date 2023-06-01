import { Controller } from "@hotwired/stimulus"
import { initFlatpicker } from "../plugins/flatpickr"

export default class extends Controller {
  connect() {
    initFlatpicker()
  }
}
