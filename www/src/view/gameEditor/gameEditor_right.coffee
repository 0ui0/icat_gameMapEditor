import gEData from "./gameEditor_data"
import Box from "../common/box"
import getColor from "../help/getColor"

import Paper from "./gameEditor_paper"


export default ->
  fnDown = fnMove = fnUp = fnWheel = null
  x1 = y1 = x2 = y2 = null

  view:->

    m "",
      style:
        width:"100%"
        height:"100vh"
        overflow:"auto"
        
    ,[
      m "",
        style:
          position:"relative"
          background:"#eee"
        oncreate:({dom})->
          #鼠标移动画布
          unless fnDown
            dom.addEventListener "mousedown",fnDown = (e)=>
              if e.button isnt 1
                return
              x1 = e.clientX
              y1 = e.clientY

              unless fnMove
                dom.addEventListener "mousemove",fnMove = (e)=>

                  x2 = e.clientX
                  y2 = e.clientY
                  disX = x2-x1
                  disY = y2-y1
                  gEData.paper.x += disX
                  gEData.paper.y += disY
                  x1 = x2
                  y1 = y2
                  m.redraw()
              
              unless fnUp
                dom.addEventListener "mouseup",fnUp =(e)=>
                  if e.button isnt 1
                    return
                  fnMove = dom.removeEventListener "mousemove",fnMove
                  fnUp = dom.removeEventListener "mouseup",fnUp

          unless fnWheel
            dom.addEventListener "wheel",fnWheel = (e)->
              unless gEData.downkeys[0] is 91 or gEData.downkeys[0] is 93
                return
              scale = -e.deltaY/1000
              console.log scale
              if 0.005 < gEData.paper.scale + scale < 20
                gEData.paper.scale +=scale
              m.redraw()
              e.preventDefault()
            ,
              passive:false
      ,[
        #画布
        m Paper
        #绘图
        

        #右键菜单
        m gEData.RightMenu,
          show:false
          style:
            position:"fixed"
            top:gEData.rightMenuTop-20+"px"
            left:gEData.rightMenuLeft-20+"px"
            zIndex:99999
            transition:"all 0.5s ease"
        ,[
          gEData.RightMenu.data.items.map (item)=>
            m Box,
              isBtn:true
              oncreate:({dom})->
                dom.addEventListener "click",(e)->
                  item.click(e)
                  m.redraw()
                  e.stopPropagation()
                ,
                  passive:false
            ,item.name
        ]
      ]
    ]