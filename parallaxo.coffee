window.parallaxo = (options = {}) ->
  options.selector ?= '.parallaxo'
  options.minWidth ?= 768
  options.preRenderPixel ?= 50
  options.defaultSpeed ?= 10

  if window.innerWidth < options.minWidth
    return false

  cache = []
  windowHeight = window.innerHeight

  scroll = () ->
    scrollTop = window.scrollY
    cache.forEach (item) ->
      if item.pos_y <= scrollTop + windowHeight + options.preRenderPixel and scrollTop <= item.pos_y + item.height + options.preRenderPixel
        value = scrollTop / item.speed + item.img_offset
        if value < 0
          value = 0

        item.element.style.webkitTransform = 'translate3d(0, -' + value + 'px, 0)'
        item.element.style.transform = 'translate3d(0, -' + value + 'px, 0)'

  request_scroll = () ->
    window.requestAnimationFrame scroll

  onload = window.onload
  window.onload = () ->
    [].forEach.call document.querySelectorAll(options.selector), (el) ->
      img_url = window.getComputedStyle(el, false).backgroundImage
      img_url = img_url.slice(0, img_url.length - 1).substr(4).replace(/["']/g, '')
      el.style.backgroundImage = 'none'

      img = document.createElement 'img'
      img.src = img_url
      img.className = 'parallaxo_img'
      el.insertBefore img, el.firstChild

      s = el.dataset['speed'] ? options.defaultSpeed
      o = el.dataset['offset'] ? 0

      cache.push {
        element: img
        height: el.offsetHeight
        pos_y: el.offsetTop
        speed: parseFloat(s) - 1
        img_offset: parseFloat(o)
      }

    if cache.length
      window.addEventListener 'scroll', request_scroll, false

    onload() if typeof onload == 'function'