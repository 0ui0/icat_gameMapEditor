export default ->
  # 定义全局检测设备类型变量
  window.DEV = null
  window.Mob = false
  window.resizeFns = []
  _bakPush = resizeFns.push
  resizeFns.push = (newItem)->
    if (oldItem = resizeFns.find (item)=> String(item) is String (newItem) and item isnt newItem) isnt -1
      resizeFns.splice resizeFns.indexOf(oldItem),1
    _bakPush.bind(@)(newItem)




  do ->
    fn = ->
      root = document.documentElement or document.body
      window.pageWidth = root.clientWidth
      window.DEV = if pageWidth <= 700 then "mobile" #768
      else if (700 < pageWidth <= 1024) then "tablet"
      else if (1024 < pageWidth <= 1215) then "desktop"
      else if (1215 < pageWidth <= 1500) then "wideScreen"
      else if (pageWidth > 1500) then "fullHD"

      if window.DEV is "mobile"
        window.Mob = true
      else
        window.Mob = false
        
      switch window.DEV
        when "mobile"
          root.style["font-size"] = Math.ceil(root.clientWidth/(440/10)) + "px"
        when "wideScreen"
          root.style["font-size"] = 11 + "px"
        when "fullHD"
          root.style["font-size"] = 11 + "px"
        else
          root.style["font-size"] = 10 + "px"
    fn()
    window.addEventListener "resize",->    
      fn()
      resizeFns.forEach (fn)=> 
        if fn
          fn()
      m.redraw()