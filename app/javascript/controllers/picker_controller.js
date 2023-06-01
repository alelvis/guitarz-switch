import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="picker"
export default class extends Controller {
  connect() {
  }

  changeImage() {
    document.querySelector(".primary-image").src=this.element.src
  }

}
