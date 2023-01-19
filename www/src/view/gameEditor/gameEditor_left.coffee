import gEData from "./gameEditor_data"
import Layer from "./gameEditor_layer"
import Box from "../common/box"
import getColor from "../help/getColor"
import Tag from "../common/tag"
export default
  view:->
    m "",
      style:
        height:"100vh"
        display:"flex"
        flexDirection:"column"
        width:"30rem"
    ,[
      m "",
        style:
          transition:"all 0.4s ease"
          background:"#fff"
          position:"relative"
          zIndex:999999999
          userSelect:"none"
          userDrag:"none"
          width:gEData.leftWidth + "rem"
          height:gEData.leftHeight + "rem"
          minHeight:gEData.leftHeight + "rem"
          border:if gEData.leftWidth is 70
            "3rem solid #{getColor("yellow").back}"
          else
            "0.5rem solid #{getColor("yellow").back}"
          borderRadius:"1rem"
          boxSizing:"border-box"
          overflow:"auto"
        oncreate:({dom})=>
          x1=y1=x2=y2=fnMove=fnUp=domX=domY=null
          domX = dom.getBoundingClientRect().x
          domY = dom.getBoundingClientRect().y

          timer = null
          timer2 = null

          scrollTimerLevel = null
          scrollTimerCross = null

          isMoving = false

          dom.addEventListener "mouseover",()->
            gEData.pen.x = 0
            gEData.pen.y = 0
            m.redraw()

            timer = clearTimeout timer

            timer2 = setTimeout ->
              gEData.leftWidth = 70
              gEData.leftHeight = 70
              m.redraw()
            ,200
          
          dom.addEventListener "mouseout",()->
            if isMoving
              return
            timer2 = clearTimeout timer2
            timer = setTimeout ->
              gEData.leftWidth = 30
              gEData.leftHeight = 40
              m.redraw()
            ,200
            


          dom.addEventListener "mousedown",(e1)->

            if e1.button isnt 0
              return

            x1 = e1.offsetX
            y1 = e1.offsetY
            x2 = x1
            y2 = y1

            gEData.texture = ""
            

            gEData.choiseBox.x = gEData.getBoxXFl(x1)
            gEData.choiseBox.y = gEData.getBoxXFl(y1)
            gEData.choiseBox.w = gEData.getW()
            gEData.choiseBox.h = gEData.getH()

            m.redraw()

            document.addEventListener "mousemove",fnMove = (e2)->

              e2.stopPropagation()

              isMoving = true

              #滚动条移动

              domWidth = getComputedStyle(dom).width.match(/\d+/)*1
              domHeight = getComputedStyle(dom).height.match(/\d+/)*1

              if e2.clientX - domWidth >= 0
                scrollTimerLevel = clearInterval scrollTimerLevel
                unless scrollTimerLevel
                  scrollTimerLevel = setInterval ->
                    dom.scrollLeft += 10
                  ,10
              else if Math.abs(e2.clientX - domWidth) > domWidth-50
                scrollTimerLevel = clearInterval scrollTimerLevel
                unless scrollTimerLevel
                  scrollTimerLevel = setInterval ->
                    dom.scrollLeft -= 10
                  ,10
              else
                scrollTimerLevel = clearInterval scrollTimerLevel

              if e2.clientY - domHeight >= 0
                scrollTimerCross = clearInterval scrollTimerCross
                unless scrollTimerCross
                  scrollTimerCross = setInterval ->
                    dom.scrollTop += 10
                  ,10
              else if  Math.abs(e2.clientY - domHeight) >= domHeight-50
                scrollTimerCross = clearInterval scrollTimerCross
                unless scrollTimerCross
                  scrollTimerCross = setInterval ->
                    dom.scrollTop -= 10
                  ,10
              else
                scrollTimerCross = clearInterval scrollTimerCross
              
              
              x2 = e2.offsetX
              y2 = e2.offsetY

              if Math.abs(x2-x1) < 5 or Math.abs(y2-y1) < 5
                return
                
              disX = x2-x1
              disY = y2-y1
            
              gEData.choiseBox.x = if disX > 0 then x1 else x2
              gEData.choiseBox.w = Math.abs(x2-x1)
              gEData.choiseBox.y = if disY > 0 then y1 else y2
              gEData.choiseBox.h = Math.abs(y2-y1)

              #坐标取格子
              
              if disX > 0
                gEData.choiseBox.x = gEData.getBoxXFl(gEData.choiseBox.x)
                gEData.choiseBox.w = gEData.getBoxX(gEData.choiseBox.w)
              else
                gEData.choiseBox.x = gEData.choiseBox.x
                gEData.choiseBox.w = gEData.choiseBox.w

              if disY > 0
                gEData.choiseBox.y = gEData.getBoxYFl(gEData.choiseBox.y)
                gEData.choiseBox.h = gEData.getBoxY(gEData.choiseBox.h)
              else
                gEData.choiseBox.y = gEData.choiseBox.y
                gEData.choiseBox.h = gEData.choiseBox.h


              
              m.redraw()

            document.addEventListener "mouseup",fnUp = (e3)->

              isMoving = false

              scrollTimerLevel = clearInterval scrollTimerLevel
              scrollTimerCross = clearInterval scrollTimerCross
            
              gEData.choiseBox.x = gEData.getBoxXFl(gEData.choiseBox.x)
              gEData.choiseBox.y = gEData.getBoxYFl(gEData.choiseBox.y)
              gEData.choiseBox.w = gEData.getBoxX(gEData.choiseBox.w)
              gEData.choiseBox.h = gEData.getBoxY(gEData.choiseBox.h)

              m.redraw()

              #裁剪图片
              ###
              setTimeout ->
                canvas = document.createElement "canvas"
                ctx = canvas.getContext "2d"
                ctx.drawImage gEData.textureDom,
                  gEData.choiseBox.x,
                  gEData.choiseBox.y,
                  gEData.choiseBox.w,
                  gEData.choiseBox.h,
                  0,
                  0,
                  gEData.choiseBox.w,
                  gEData.choiseBox.h
                gEData.texture = canvas.toDataURL "image/png"
                m.redraw()
              ,500
              ###
              
              document.removeEventListener "mousemove",fnMove
              document.removeEventListener "mouseup",fnUp


      ,[
        m "img",
          oncreate:({dom})=>
            gEData.textureDom = dom
          
          src:gEData.tilesetUrl
          style:
            userSelect:"none"
            "-webkit-user-drag":"none"
            
            
        m "",
          style:
            position:"absolute"
            left:0
            top:0
            #translate:"#{gEData.choiseBox.x}px #{gEData.choiseBox.y}px"
            transform:"translate(#{gEData.choiseBox.x}px,#{gEData.choiseBox.y}px)"

            width:"#{gEData.choiseBox.w}px"
            height:"#{gEData.choiseBox.h}px"
            background:"rgba(255,200,50,0.5)"
            border:"2px solid white"
            boxSizing:"border-box"
            pointerEvents: "none"
            #transition:"0.2s all"
      ]

      m "",
        style:
          display:"flex"
          alignItems:"center"
          flexWrap:"wrap"
          background:"#eee"
      ,[
        m "label",
          style:
            position:"relative"
        ,[
          m "input[type=file]",
            multiple:true
            style:
              width:"100%"
              height:"100%"
              position:"absolute"
              zIndex:-1
              left:0
              top:0
              opacity:0
            onchange:(e)=>
              #gEData.tilesets = []
              for file in e.target.files
                dataURL = await new Promise (res,rej)=>
                  fileReader = new FileReader()
                  fileReader.onload = ->
                    res(@result)
                  fileReader.readAsDataURL file
                gEData.tilesets.push dataURL
              e.target.value = null #清空浏览器的文件记录
              

          m Box,
            color:"yellow"
            isBtn:yes
            style:
              maginTop:0
              marginLeft:"0.2rem"
              marginRight:"0.2rem"
              borderRadius:"0 0 1rem 1rem"
          ,"添加"


        ]

        m Tag,
          isBtn:yes
          color:"red"
          styleExt:
            margin:"0.2rem"
          onclick:=>
            gEData.tilesetUrl = "./statics/green/tileset/prohibit.png"
        ,"0"

        gEData.tilesets.map (tileset,index)=>
          m Tag,
            isBtn:yes
            color:"green"
            styleExt:
              margin:"0.2rem"
            onclick:=>
              gEData.tilesetUrl = tileset          
          ,"#{index+1}"


      ]

      m Layer
      
    ]