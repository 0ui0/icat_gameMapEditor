import gEData from "./gameEditor_data"
import Box from "../common/box"
import getColor from "../help/getColor"

import Paper from "./gameEditor_paper"


export default
  

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
      ,[

        #画布
        m Paper

        #绘图
        if gEData.mouseState is "pen"
          m "",
            style:
              position:"absolute"
              left:0
              top:0
              #translate:"#{gEData.pen.x}px #{gEData.pen.y}px"
              transform:"translate(#{gEData.pen.x}px,#{gEData.pen.y}px)"
              width:"#{gEData.choiseBox.w}px"
              height:"#{gEData.choiseBox.h}px"
              backgroundColor:"rgba(200,255,50,0.5)"
              backgroundImage:"url(#{gEData.tilesetUrl})"
              backgroundPosition:"-#{gEData.choiseBox.x}px -#{gEData.choiseBox.y}px"
              backgroundRepeat:"no-repeat"
              border:"2px solid white"
              boxSizing:"border-box"
              pointerEvents: "none"
              #transition:"0.1s all"
              zIndex:"999999"

        #框选
        
        m "",
          style:
            position:"absolute"
            left:0
            top:0
            #translate:"#{gEData.choiseBox2.x}px #{gEData.choiseBox2.y}px"
            transform:"translate(#{gEData.choiseBox2.x}px,#{gEData.choiseBox2.y}px)"
            width:"#{gEData.choiseBox2.w}px"
            height:"#{gEData.choiseBox2.h}px"
            backgroundColor:"rgba(255,255,255,0.2)"
            border:if gEData.choiseBox2.w > 0 or gEData.choiseBox2.h > 0
              "2px solid #ccc"
            boxSizing:"border-box"
            pointerEvents: "none"
            #transition:"0.2s all"
            zIndex:"999999"

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