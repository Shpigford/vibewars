// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Handling data-confirm in Rails 7 since UJS is gone
document.addEventListener("turbo:submit-start", (event) => {
  confirmSubmission(event).then(() => {
    // show progress bar and set submit state here.
    // this block is optional.
  })
})

function confirmSubmission(event) {
  const button = event.target.querySelector("[data-confirm]")
  const message = button?.dataset?.confirm

  return new Promise(resolve => {
    if (!message || confirm(message)) {
      resolve()
    } else {
      event.detail.formSubmission.stop()
      event.preventDefault()
      event.stopImmediatePropagation()
    }
  })
}