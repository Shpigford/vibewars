import { Controller } from "@hotwired/stimulus"
import { ensNameOrAddress } from '../ens';

export default class extends Controller {
  static values = {
    address: String,
  }

  async addressValueChanged() {
    const ensName = await ensNameOrAddress(this.addressValue);
    this.element.innerText = ensName.replace(/^0x(.{5}).+(.{4})$/, '0x$1…$2');
  }
}
