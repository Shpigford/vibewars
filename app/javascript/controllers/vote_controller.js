import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="vote"
export default class extends Controller {
  static targets = ["element"];

  toggle(event) {
    //event.preventDefault();
    event.target.classList.add("opacity-100");
    event.target.classList.remove("opacity-0");
  }
}
