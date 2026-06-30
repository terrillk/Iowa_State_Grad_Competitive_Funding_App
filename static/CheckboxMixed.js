/*
 *   This content is licensed according to the W3C Software License at
 *   https://www.w3.org/Consortium/Legal/2015/copyright-software-and-document
 *
 *   File:   CheckboxMixed.js
 *
 *   Desc:   CheckboxMixed widget that implements ARIA Authoring Practices
 *           for a menu of links
 */




'use strict';

class CheckboxMixed {
  constructor(domNode) {
    this.mixedNode = domNode.querySelector('[role="checkbox"]');
    this.checkboxNodes = domNode.querySelectorAll('input[type="checkbox"]');

    this.mixedNode.addEventListener('keydown', this.onMixedKeydown.bind(this));
    this.mixedNode.addEventListener('keyup', this.onMixedKeyup.bind(this));
    this.mixedNode.addEventListener('click', this.onMixedClick.bind(this));
    this.mixedNode.addEventListener('focus', this.onMixedFocus.bind(this));
    this.mixedNode.addEventListener('blur', this.onMixedBlur.bind(this));

    for (var i = 0; i < this.checkboxNodes.length; i++) {
      var checkboxNode = this.checkboxNodes[i];

      checkboxNode.addEventListener('click', this.onCheckboxClick.bind(this));
      checkboxNode.addEventListener('focus', this.onCheckboxFocus.bind(this));
      checkboxNode.addEventListener('blur', this.onCheckboxBlur.bind(this));
      checkboxNode.setAttribute('data-last-state', checkboxNode.checked);
    }

    this.updateMixed();
  }

  updateMixed() {
    let checkedCount = 0;

    for (let i = 0; i < this.checkboxNodes.length; i++) {
      if (this.checkboxNodes[i].checked) {
        checkedCount++;
      }
    }

    if (checkedCount === 0) {
      this.mixedNode.setAttribute('aria-checked', 'false');
    } 
    else if (checkedCount === this.checkboxNodes.length) {
        this.mixedNode.setAttribute('aria-checked', 'true');
      } 
    else {
        this.mixedNode.setAttribute('aria-checked', 'mixed');
      }
  }
  

  updateCheckboxStates() {
    for (var i = 0; i < this.checkboxNodes.length; i++) {
      var checkboxNode = this.checkboxNodes[i];
      checkboxNode.setAttribute('data-last-state', checkboxNode.checked);
    }
  }

  anyLastChecked() {

    for (let i = 0; i < this.checkboxNodes.length; i++) {
      if (this.checkboxNodes[i].getAttribute('data-last-state') === 'true') {
        return true;
      }
    }

    return false;
  }

  setCheckboxes(value) {
    for (let i = 0; i < this.checkboxNodes.length; i++) {
      let checkboxNode = this.checkboxNodes[i];
      checkboxNode.checked = value;
      checkboxNode.setAttribute('data-last-state', value);
    }
  }

  toggleMixed() {
    let state = this.mixedNode.getAttribute('aria-checked');

    let newValue;

    if (state === 'true') {
      newValue = false; // all checked -> uncheck all
    } else {
      newValue = true; // none/mixed -> check all
    }

    // apply to all checkboxes in this fieldset
    for (let i=0; i< this.checkboxNodes.length; i++) {
      let cb = this.checkboxNodes[i];
      cb.checked = newValue;
      cb.setAttribute('data-last-state', newValue);
    }

    this.updateMixed();
  }

  /* EVENT HANDLERS */

  // Prevent page scrolling on space down
  onMixedKeydown(event) {
    if (event.key === ' ') {
      event.preventDefault();
    }
  }

  onMixedKeyup(event) {
    switch (event.key) {
      case ' ':
        this.toggleMixed();
        event.stopPropagation();
        break;

      default:
        break;
    }
  }

  onMixedClick() {
    this.toggleMixed();
  }

  onMixedFocus() {
    this.mixedNode.classList.add('focus');
  }

  onMixedBlur() {
    this.mixedNode.classList.remove('focus');
  }

  onCheckboxClick(event) {
    event.currentTarget.setAttribute(
      'data-last-state',
      event.currentTarget.checked
    );
    this.updateMixed();
  }

  onCheckboxFocus(event) {
    event.currentTarget.parentNode.classList.add('focus');
  }

  onCheckboxBlur(event) {
    event.currentTarget.parentNode.classList.remove('focus');
  }
}

// Initialize mixed checkboxes on the page
// **** the event listener below was disabled by Kristin Terrill on 6/23/2026 per
// recommendation from CoPilot to replace with  an htmx-accommodating alternative initializer.
// ***
// window.addEventListener('load', function () {
//   let mixed = document.querySelectorAll('.checkbox-mixed');
//   for (let i = 0; i < mixed.length; i++) {
//     new CheckboxMixed(mixed[i]);
//   }
// });

/*
  New content: written by CoPilot on 6/23/2026.
  This section adds an initializer that allows the checkboxMixed to re-initialize if the HTML 
  is loaded after page load, for example in htmx swap.
*/

function initCheckboxMixed(root = document) {
  let mixed = root.querySelectorAll('.checkbox-mixed');

  for (let i = 0; i< mixed.length; i++) {
    // avoid re-binding events if HTMX swaps repeatedly:
    if (mixed[i].dataset.initialized) continue;
    mixed[i].dataset.initialized = "true";
    // end double-bind prevention code

    const widget = new CheckboxMixed(mixed[i]);
    const master = widget.mixedNode;
    const checkboxes = widget.checkboxNodes;

    if (!master) continue;

    // //bind master checkbox behavior
    // master.addEventListener('click', widget.onMixedClick.bind(widget));
    // master.addEventListener('keydown', widget.onMixedKeydown.bind(widget));
    // master.addEventListener('keyup', widget.onMixedKeyup.bind(widget));
    // master.addEventListener('focus', widget.onMixedFocus.bind(widget));
    // master.addEventListener('blur', widget.onMixedBlur.bind(widget));

    // // bind each checkbox    
    // checkboxes.forEach(cb => {
    //     cb.addEventListener('click', widget.onCheckboxClick.bind(widget));
    //     cb.addEventListener('focus', widget.onCheckboxFocus.bind(widget));
    //     cb.addEventListener('blur', widget.onCheckboxBlur.bind(widget));
    // });

    // initialize state tracking
    widget.updateCheckboxStates();
    widget.updateMixed();

  }
}

// initial page load
window.addEventListener('DOMContentLoaded', function () {
  initCheckboxMixed(document);
});

// htmx hook
document.body.addEventListener('htmx:afterSwap', function (event) {
  initCheckboxMixed(event.target);
});