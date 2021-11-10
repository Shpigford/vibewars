import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="vote"
export default class extends Controller {
  static targets = ["element", "itemFirst", "itemLast"];

  toggle(event) {
    event.target.classList.add("opacity-100");
    event.target.classList.remove("opacity-0");
  }

  keypress(event) {
    if (event.key == 'ArrowLeft') {
      this.itemFirstTarget.querySelector('.voted').classList.add("opacity-100");
      this.itemFirstTarget.querySelector('.voted').classList.remove("opacity-0");

      this.itemFirstTarget.click();
    }
    else if (event.key == 'ArrowRight') {
      this.itemLastTarget.querySelector('.voted').classList.add("opacity-100");
      this.itemLastTarget.querySelector('.voted').classList.remove("opacity-0");

      this.itemLastTarget.click();
    }
  }
}
