###!
  Parallaxo <http://rhurling.github.io/parallaxo>
  by Rouven Hurling <rouven@rhurling.de>

  MIT LICENSE
###

window.parallaxo = (options = {}) ->
  # set default options
  options.selector ?= '.parallaxo'
  options.minWidth ?= 768
  options.preRenderPixel ?= 50
  options.defaultSpeed ?= 7.5
  options.preventWhiteBackground ?= true

  # bail early if minWidth is not reached
  if window.innerWidth < options.minWidth
    return false

  # set empty cache and cache windowHeight
  cache = []
  windowHeight = window.innerHeight

  scroll = () ->
    # cache scrollPosition
    scrollTop = window.scrollY
    cache.forEach (item) ->
      # check if element is almost visible
      if item.pos_y <= scrollTop + windowHeight + options.preRenderPixel and scrollTop <= item.pos_y + item.height + options.preRenderPixel
        # calculate y-value of translate3d
        value = scrollTop / item.speed + item.img_offset
        # catch negative values
        value = 0 if value < 0
        # check if value larger than max allowed value to prevent a white background if the image is pushed to far to the top
        value = item.max_translate if options.preventWhiteBackground and value > item.max_translate

        item.element.style.webkitTransform = 'translate3d(0, -' + value + 'px, 0)'
        item.element.style.transform = 'translate3d(0, -' + value + 'px, 0)'

  # requestAnimationFrame if needed
  request_scroll = () ->
    if cache.length
      window.requestAnimationFrame scroll

  # cache possible onload function to call later
  onload = window.onload
  window.onload = () ->
    onload() if typeof onload == 'function'

    # loop through
    [].forEach.call document.querySelectorAll(options.selector), (el) ->
      # get url of background image
      img_url = window.getComputedStyle(el, false).backgroundImage
      img_url = img_url.slice(0, img_url.length - 1).substr(4).replace(/["']/g, '')

      # set vars
      speed = el.dataset['speed'] ? options.defaultSpeed
      img_offset = el.dataset['offset'] ? 0

      # create image and wait for onloadevent
      img = document.createElement 'img'
      img.src = img_url
      img.className = 'parallaxo_img'
      img.onload = () ->
        # remove background-image and insert img tag
        el.style.backgroundImage = 'none'
        el.insertBefore img, el.firstChild

        # add to element cache
        cache.push {
          element: img
          speed: parseFloat(speed) - 1

          height: el.offsetHeight
          pos_y: el.offsetTop

          img_offset: parseFloat(img_offset)
          max_translate: img.height - el.offsetHeight
        }

    window.addEventListener 'scroll', request_scroll, false