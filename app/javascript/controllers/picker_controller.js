import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="picker"
export default class extends Controller {

  static targets = ['pimage']

  connect() {
  }

  changeImage(event) {
    const bigImage = this.pimageTarget;
    const smallImage = event.target;
    const bigImageSrc = bigImage.src
    bigImage.src = smallImage.src;
    smallImage.src = bigImageSrc
  }
}
