// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import { Socket } from "phoenix"
import NProgress from "nprogress"
import { LiveSocket } from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken } })

// Show progress bar on live navigation and form submits
window.addEventListener("phx:page-loading-start", info => NProgress.start())
window.addEventListener("phx:page-loading-stop", info => NProgress.done())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket



// Desktop User Menu open/close state
const userMenu = document.getElementById('user-menu')
const userMenuButton = document.getElementById('user-menu-button')
userMenuButton && userMenuButton.addEventListener('click', (e) => {
    e.stopPropagation()
    // if menu is open, close it
    if (userMenu.classList.contains('block')) {
        userMenu.classList.replace('block', 'hidden')
    }
    // if menu is closed, open it
    else {
        userMenu.classList.replace('hidden', 'block')
    }
})
window.addEventListener('click', (e) => {
    if (event.target != userMenu) {
        userMenu.classList.replace('block', 'hidden')
    }
});


// Mobile Menu open/close state

const mobileMenu = document.getElementById('mobile-menu')
const mobileMenuButton = document.getElementById('mobile-menu-button')
const mobileMenuButtonOpen = document.getElementById('mobile-menu-button-open')
const mobileMenuButtonClose = document.getElementById('mobile-menu-button-close')
mobileMenuButton && mobileMenuButton.addEventListener('click', (e) => {
    // if menu is open, close it
    if (mobileMenu.classList.contains('block')) {
        mobileMenu.classList.replace('block', 'hidden')
        mobileMenuButtonOpen.classList.replace('hidden', 'block')
        mobileMenuButtonClose.classList.replace('block', 'hidden')
    }
    // if menu is closed, open it
    else {
        mobileMenu.classList.replace('hidden', 'block')
        mobileMenuButtonOpen.classList.replace('block', 'hidden')
        mobileMenuButtonClose.classList.replace('hidden', 'block')
    }
})
