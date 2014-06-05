class @Parallaxo
  cache: []
  selector: '.parallaxo'

  constructor: (selector = @selector) ->
    cache = @cache

    [].forEach.call(document.querySelectorAll(selector), (el) ->
      s = el.getAttribute('data-speed')
      s = 10 if !s

      cache.push {
        element: el,
        speed: parseInt(s) - 1,
        offset: el.offsetTop
      }
    )

    @cache = cache

    if cache.length
      window.addEventListener 'scroll', @scroll, false
      @scroll()

  scroll: =>
    scrollTop = window.scrollY

    @cache.forEach( (item) ->
      console.log scrollTop, item.offset, scrollTop - item.offset
      item.element.style.backgroundPosition = '50% ' + ( ( scrollTop - item.offset ) / item.speed * -1 ) + 'px'
    )

  destroy: =>
    window.removeEventListener 'scroll', @scroll, false
    @cache = []