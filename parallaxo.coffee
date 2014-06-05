window.parallaxo = () ->
  cache = []
  windowHeight = window.innerHeight

  scroll = () ->
    scrollTop = window.scrollY
    cache.forEach (item) ->
      if item.offset <= scrollTop + windowHeight + 50 and scrollTop <= item.offset + item.height + 50
        item.element.style.webkitTransform = 'translate3d(0, -' + ( scrollTop / item.speed ) + 'px, 0)'
        item.element.style.transform = 'translate3d(0, -' + ( scrollTop / item.speed ) + 'px, 0)'

  request_scroll = () ->
    window.requestAnimationFrame scroll

  onload = window.onload
  window.onload = () ->
    [].forEach.call document.querySelectorAll('.parallaxo'), (el) ->
      img_url = window.getComputedStyle(el, false).backgroundImage
      img_url = img_url.slice(0, img_url.length - 1).substr(4).replace(/["']/g, '')
      el.style.backgroundImage = 'none'

      img = document.createElement 'img'
      img.src = img_url
      img.className = 'parallaxo_img'
      el.insertBefore img, el.firstChild

      s = el.getAttribute('data-speed')
      s = 10 if !s

      cache.push {
        element: img
        height: el.offsetHeight
        speed: parseInt(s) - 1
        offset: el.offsetTop
      }

    if cache.length
      window.addEventListener 'scroll', request_scroll, false

    onload()