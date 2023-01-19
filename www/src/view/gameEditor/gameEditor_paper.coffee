import gEData from "./gameEditor_data"
import Box from "../common/box"
import getColor from "../help/getColor"
import {v4 as uuid} from "uuid"
import PreDiv from "./gameEditor_preDiv"
import autoDraw from "./gameEditor_autoDraw"

export default ->
  fnOut = fnDown1 = fnDown2 = fnDown3 = fnMove = fnDown1_move = fnDown1_up = fnDown2_move = fnDown2_up = fnDown3_up = null
  
  view:()->
    m "#paper",
      oncreate:({dom})=>
        dir = ""
        img = null

        paperRect =
          data:null
          update:->
            @data = dom.getBoundingClientRect()
          getMousePaperSite:(mouseEvent)->
            return {
              x:(mouseEvent.clientX - @data.x)/gEData.paper.scale
              y:(mouseEvent.clientY - @data.y)/gEData.paper.scale
            }

        unless fnOut
          dom.addEventListener "mouseout",fnOut = (e)->
            gEData.pen.show = false
            m.redraw()
            ###

            fnDown1 = dom.removeEventListener "mousedown",fnDown1
            fnDown2 = dom.removeEventListener "mousedown",fnDown2
            fnMove = dom.removeEventListener "mousemove",fnMove
            fnDown1_move = dom.removeEventListener "mousemove",fnDown1_move
            fnDown2_move = dom.removeEventListener "mousemove",fnDown2_move
            fnDown1_up = dom.removeEventListener "mouseup",fnDown1_up
            fnDown2_up = dom.removeEventListener "mouseup",fnDown2_up
            ###

            #fnOut = dom.removeEventListener "mouseout",fnOut
        
        unless fnOver
          dom.addEventListener "mouseover",fnOver = (e1)->

            paperRect.update()

            {
              x:x1
              y:y1
            } = paperRect.getMousePaperSite(e1)


            if gEData.mouseState is "pen"
              gEData.pen.show = true
            else
              gEData.pen.show = false

            m.redraw()

            unless fnMove
              dom.addEventListener "mousemove",fnMove = (e2)->
                if gEData.mouseState isnt "pen" #画笔跟随
                  return
                
                paperRect.update()
                
                {x:x2,y:y2} = paperRect.getMousePaperSite(e2)

                gEData.pen.x = gEData.getBoxX x2
                gEData.pen.y = gEData.getBoxY y2

                m.redraw()

            #绘图器

            unless fnDown1
              dom.addEventListener "mousedown",fnDown1 = (e3)->
                if e3.button isnt 0
                  return
                #console.log "down"
                if gEData.mouseState isnt "pen" #画笔绘制按下
                  return
                
                paperRect.update()
                {x:x3,y:y3} = paperRect.getMousePaperSite(e3)

                if gEData.autoDraw #自动元件

                  autoDraw(x1,y1,x3,y3,true)
                  #=======

                  m.redraw()

                else

                  preDiv = new PreDiv
                    id:uuid()
                    x:gEData.getBoxX(x3)
                    y:gEData.getBoxY(y3)
                    imgX:gEData.choiseBox.x
                    imgY:gEData.choiseBox.y
                    imgW:gEData.choiseBox.w
                    imgH:gEData.choiseBox.h
                    url:gEData.tilesetUrl

                  gEData.divList.addNoRepeat preDiv

                
                unless fnDown1_move
                  dom.addEventListener "mousemove",fnDown1_move = (e4)->
                    if gEData.mouseState isnt "pen" #画笔绘制跟随
                      return

                    paperRect.update()
                    {x:x4,y:y4} = paperRect.getMousePaperSite(e4)

                      
                    if gEData.autoDraw
                      autoDraw(x3,y3,x4,y4)

                    else

                      if ((gEData.getBoxX(x4)-gEData.getBoxX(x3)) % gEData.choiseBox.w is 0 and
                      (gEData.getBoxY(y4)-gEData.getBoxX(y3))%gEData.choiseBox.h is 0)
                        preDiv = new PreDiv
                          id:uuid()
                          x:gEData.getBoxX(x4)
                          y:gEData.getBoxY(y4)
                          imgX:gEData.choiseBox.x
                          imgY:gEData.choiseBox.y
                          imgW:gEData.choiseBox.w
                          imgH:gEData.choiseBox.h
                          url:gEData.tilesetUrl

                        gEData.divList.addNoRepeat preDiv

                      
                      ###
                      img = new Image(gEData.choiseBox.w,gEData.choiseBox.h)#
                      img.src = gEData.texture

                      img.onload = ->
                        
                        ctx = dom.getContext "2d"
                        if dir is "x"
                          ctx.drawImage img,gEData.getBoxX(x4),gEData.getBoxY(y3)
                        if dir is "y"
                          ctx.drawImage img,gEData.getBoxX(x3),gEData.getBoxY(y4)
                      ###

                unless fnDown1_up
                  dom.addEventListener "mouseup",fnDown1_up = ()->
                    
                    if gEData.mouseState isnt "pen"
                      fnDown1_move = dom.removeEventListener "mousemove",fnDown1_move
                      fnDown1_up = dom.removeEventListener "mouseup",fnDown1_up
                      return

                    dir = ""
                    fnDown1_move = dom.removeEventListener "mousemove",fnDown1_move
                    fnDown1_up = dom.removeEventListener "mouseup",fnDown1_up
              

            #框选器
            unless fnDown2
              dom.addEventListener "mousedown",fnDown2 = (e3)->
                if e3.button isnt 0
                  return
                if gEData.mouseState isnt "mouse"
                  return

                if gEData.downkeys[0] isnt 16 #shift键
                  gEData.divList.data.forEach (preDiv)=>
                    preDiv.cancelSelect()

                paperRect.update()
                {x:x1,y:y1} = paperRect.getMousePaperSite(e3)


                gEData.choiseBox2.x = gEData.choiseBox2.x + gEData.choiseBox2.w
                gEData.choiseBox2.y = gEData.choiseBox2.y + gEData.choiseBox2.h
                gEData.choiseBox2.w = 0
                gEData.choiseBox2.h = 0

                m.redraw()

                unless fnDown2_move
                  document.addEventListener "mousemove",fnDown2_move = (e4)->
                    #console.log "move"
                    
                    if gEData.mouseState isnt "mouse"
                      return


                    paperRect.update()
                    {x:x2,y:y2} = paperRect.getMousePaperSite(e4)
                    

                    disX = x2-x1
                    disY = y2-y1

                    if disX > 0
                      gEData.choiseBox2.x = x1
                      gEData.choiseBox2.w = Math.abs disX
                    else
                      gEData.choiseBox2.x = x2
                      gEData.choiseBox2.w = Math.abs disX
                    if disY > 0
                      gEData.choiseBox2.y = y1
                      gEData.choiseBox2.h = Math.abs disY
                    else
                      gEData.choiseBox2.y = y2
                      gEData.choiseBox2.h = Math.abs disY


                    m.redraw()


                unless fnDown2_up
                  document.addEventListener "mouseup",fnDown2_up = (e5)->

                    if gEData.mouseState isnt "mouse"
                      fnDown2_move = document.removeEventListener "mousemove",fnDown2_move
                      fnDown2_up = document.removeEventListener "mouseup",fnDown2_up
                      return

                    gEData.divList.selectRectItems()

                      




                    m.redraw()

                    fnDown2_move = document.removeEventListener "mousemove",fnDown2_move
                    fnDown2_up = document.removeEventListener "mouseup",fnDown2_up



            #右键
            unless fnDown3
              dom.addEventListener "contextmenu",fnDown3 = (e)->
                if gEData.mouseState isnt "mouse"
                  return
                if gEData.divList.getSelectedItems().length <=0
                  return
                gEData.RightMenu.data.show = true
                gEData.rightMenuTop = e.clientY
                gEData.rightMenuLeft = e.clientX
                gEData.RightMenu.data.items = [
                  {
                    name:"上移一层"
                    click:->
                      gEData.divList.changeZIndexSelectedItems 5
                  }
                  {
                    name:"下移一层"
                    click:->
                      gEData.divList.changeZIndexSelectedItems -5
                  }
                  {
                    name:"编组"
                    click:->
                      gEData.divList.becomeGroup()
                      gEData.RightMenu.data.show = false
                  }
                  {
                    name:"拆散"
                    click:->
                      gEData.divList.exitGroup()
                      gEData.RightMenu.data.show = false

                  }
                  {
                    name:"删除"
                    click:->
                      gEData.divList.delSelectedItems()                
                      gEData.RightMenu.data.show = false
                      m.redraw()
                  }
                  {
                    name:"隐藏/显示"
                    click:->
                      gEData.divList.hideOrShow()
                  }
                  {
                    name:"锁定/解锁"
                    click:->
                      gEData.divList.lockOrUnlock()
                  }
                ]
                e.preventDefault()
                m.redraw()
              ,
                passive:false
                


      style:
        width:"#{gEData.canvasWidth}px"
        height:"#{gEData.canvasHeight}px"
        position:"relative"
        background:"#fff"
        overflow:"hidden"
        border:"0.1rem solid #aaa"
        transform:"translate(#{gEData.paper.x}px,#{gEData.paper.y}px) scale(#{gEData.paper.scale})"
        #left:"100px"
        #top:"100px"
    ,[
      
      gEData.divList.data.map  (preDiv,index)=>

        m "",
          key:preDiv.id
          "data-id":preDiv.id
          "data-linkid":preDiv.linkid
          oncreate:({dom})=>
            preDiv.dom = dom
            

            dom.addEventListener "click",(e)->
              e.stopPropagation()
            ,
              passive:false

            dom.addEventListener "dblclick",(e)->
              if preDiv.isGroup
                gEData.divList.setPresentGroup preDiv.id
                gEData.divList.cancelSelectAll()
              e.stopPropagation()
            ,
              passive:false

            
            dom.addEventListener "mousedown",(e1)->
              if e1.button isnt 0
                return
              e1.stopPropagation()
              x1 = e1.clientX
              y1 = e1.clientY

              gEData.RightMenu.data.show = false

              #框选shift追加或删除元素
              if gEData.downkeys[0] isnt 16 #shift键
                #如果已经选中的方块里没有当前点击的方块，就
                unless gEData.divList.getSelectedItems().find (preDiv1)=> preDiv1 is preDiv
                  gEData.divList.data.forEach (preDiv1)=>
                    preDiv1.cancelSelect()

              preDiv.select 1

              #编组情况检查
              gEData.divList.findInGroup(preDiv)?.forEach (preDiv)=>
                preDiv.select 2 #二级选中

              #清除框框
              gEData.choiseBox2.w = 0
              gEData.choiseBox2.h = 0

              m.redraw()

              #点击document取消选中，不需要，因为同时触发了新的框选器
              ###
              document.addEventListener "click",fnClick = ()=>
                gEData.divList.data.forEach (preDiv1)=>
                  preDiv1.cancelSelect()
                m.redraw()
                document.removeEventListener "click",fnClick
              ###

              document.addEventListener "mousemove",fnMove = (e2)->
                e2.stopPropagation()
                unless preDiv.hasBorder
                  return
                x2 = e2.clientX
                y2 = e2.clientY

                disX = (x2-x1)/gEData.paper.scale
                disY = (y2-y1)/gEData.paper.scale

                #平移被框选元素
                gEData.divList.translateSelectedItems disX,disY

                m.redraw()
                x1=x2
                y1=y2
              ,
                passive:false
              document.addEventListener "mouseup",fnUp = (e3)->
                if e1.button isnt 0
                  return
                e3.stopPropagation()
                unless preDiv.hasBorder
                  return

                #按坐标四舍五入被选中元素
                gEData.divList.getSelectedItems().forEach (preDiv)=>
                  preDiv.x = gEData.getBoxX(preDiv.x)
                  preDiv.y = gEData.getBoxY(preDiv.y)

                
                gEData.divList.updateGroup() #更新组
                m.redraw()
                gEData.divList.record() #存储记录

                document.removeEventListener "mousemove",fnMove
                document.removeEventListener "mouseup",fnUp
              ,
                passive:false
            ,
              passive:false
          
          style:
            zIndex:preDiv.zIndex
            position:"absolute"
            left:0
            top:0
            display:"inline-block"
            opacity:if preDiv.hideState
              0
            else if preDiv.lockState
              1
            else
              if gEData.divList.isInGroup(preDiv)
                1
              else
                0.5

            #translate:"#{preDiv.x}px #{preDiv.y}px"
            transform:"translate(#{preDiv.x}px,#{preDiv.y}px)"
            width: "#{preDiv.imgW}px"
            height:"#{preDiv.imgH}px"
            backgroundImage:"url(#{preDiv.url})"
            backgroundPosition:"-#{preDiv.imgX}px -#{preDiv.imgY}px"
            backgroundRepeat:"no-repeat"
            boxSizing:"border-box"
            pointerEvents: if gEData.mouseState is "pen"
              "none"
            else
              if preDiv.lockState or preDiv.hideState
                "none"
              else
                if gEData.divList.isInGroup(preDiv)
                  "auto"
                else
                  "none"
            userSelect:"none"
            border:if preDiv.hasBorder is 1
              "0.2rem solid #{getColor("yellow").back}"
            else if preDiv.hasBorder is 2
              "0.2rem solid #{getColor("green").back}"

        ,[
          if gEData.divList.showZIndex
            m "",
              style:
                color:"white"
                fontSize:"1.3rem"
                wordBreak:"break-all"
                wordWrap:"overflow-wrap"
            ,"层级："+preDiv.zIndex
        ]












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



    
      if gEData.mouseState is "pen" #绘图器
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
    
    ]