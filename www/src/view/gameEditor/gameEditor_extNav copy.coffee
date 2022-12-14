import gEData from "./gameEditor_data"
import Box from "../common/box"
import Tag from "../common/tag"
import Notice from "../common/notice"




export default ->
  view:->
    m "",
      style:
        position:"fixed"
        bottom:"2rem"
        left:"50%"
        transform:"translate(-50%, 0px)"
        #background:getColor("yellow").back
        background:"rgba(0,0,0,0.3)"
        borderRadius:"3rem"
        minWidth:"50rem"
        display:"flex"
        justifyContent:"center"
        alignItems:"center"
    ,[
      #鼠标
      m Box,
        isBtn:yes
        color:if gEData.mouseState is "mouse" then "red"
        style:
          display:"flex"
          justifyContent:"center"
          alignItems:"center"
          flexDirection:"column"

        onclick:=>
          gEData.mouseState = "mouse"
      ,[
        m.trust iconPark.getIcon "MoveOne"
        "操作(A)"
      ]
      #画笔
      m Box,
        isBtn:yes
        color:if gEData.mouseState is "pen" then "red"
        style:
          display:"flex"
          justifyContent:"center"
          alignItems:"center"
        onclick:=>
          gEData.mouseState = "pen"
      ,[
        m.trust iconPark.getIcon "Pencil"
        "绘图(P)"
      ]

      #填充
      m Box,
        isBtn:yes
        style:
          display:"flex"
          justifyContent:"center"
          alignItems:"center"
        onclick:=>
          gEData.divList.fillRect()

      ,[
        m.trust iconPark.getIcon "BackgroundColor"
        "填充"
      ]
      ###
      m Box,
        isBtn:yes
        color:"brown"
        onclick:=>
          gEData.divList.forEach (preDiv)=>
            preDiv.hasBorder = 0
      ,"取消框选"
      ###

      m Box,
        isBtn:yes
        color:if gEData.autoDraw then "red" else "brown"
        onclick:=>
          gEData.autoDraw = !gEData.autoDraw
      ,"自动元件"

      if gEData.autoDraw
        m "",[
          m "",
            stlye:
              display:"flex"
              flexWrap:"wrap"
          ,[
            gEData.autoDrawNames.map ({en,cn})=>
              m Tag,
                isBtn:yes
                color:if gEData[en] then "deepBlue" else "green"
                onclick: =>
                  gEData[en]=
                    x:gEData.choiseBox.x
                    y:gEData.choiseBox.y
              ,cn + "#{if gEData[en] then "(#{gEData[en].x},#{gEData[en].y})" else ""}"
          ]

          m Tag,
            isBtn:yes
            onclick:=>
              gEData.clearAutoDrawConfig()

          ,"清除"
        ]

      m Box,
        isBtn:yes
        onclick:=>
          SetWidth = new Box()
          SetHeight = new Box()
          Notice.launch
            tip:"配置"
            content:->
              view:->
                m "",[
                  m Box,
                    isBlock:true
                  ,"配置画布尺寸不会影响当前已经绘制好的元素，只影响导出区域"
                  m Box,"宽#{gEData.canvasWidth}px"
                  m Box,"x"
                  m Box,"高#{gEData.canvasHeight}px"
                  m "",[
                    m SetWidth,
                      tagName:"input[type=number]"
                      ext:
                        placeholder:"画布宽/像素"
                    m SetHeight,
                      tagName:"input[type=number]"
                      ext:
                        placeholder:"画布高/像素"
                  ]
                ]
            confirm:->
              gEData.canvasHeight = SetHeight.data.value
              gEData.canvasWidth = SetWidth.data.value
              return undefined
      
      ,"配置"

      
      m Box,
        isBtn:yes
        style:
          display:"flex"
          justifyContent:"center"
          alignItems:"center"
        onclick:=>
          canvas = document.createElement "canvas"
          canvas.width = gEData.canvasWidth
          canvas.height = gEData.canvasHeight
          ctx = canvas.getContext "2d"

          divListOrder = gEData.divList.data.sort (x1,x2)=> Number(x1.dom.style.zIndex) - Number(x2.dom.style.zIndex) 

          for preDiv in divListOrder
            await do(preDiv)=>
              imgDom = await new Promise (res,rej)=>
                imgDom = new Image()
                imgDom.src = preDiv.url
                imgDom.onload = () =>
                  res(imgDom)

              ctx.drawImage imgDom,preDiv.imgX,preDiv.imgY,preDiv.imgW,preDiv.imgH,preDiv.x,preDiv.y,preDiv.imgW,preDiv.imgH
          
          data = canvas.toDataURL "image/png"
          
          aDom = document.createElement "a"
          aDom.download = "map_#{Date.now()}.png"
          aDom.href = data
          document.body.appendChild aDom
          aDom.click()
          aDom.remove()

          #document.body.appendChild canvas


            
            
            
          ###
          paper = document.querySelector "#paper"
          console.log paper
          html2canvas(paper).then (canvas)=>
            #document.body.appendChild(canvas)
            data = canvas.toDataURL "image/png"
            aDom = document.createElement "a"
            aDom.download = "map_#{Date.now()}.png"
            aDom.href = data
            document.body.appendChild aDom
            aDom.click()
            aDom.remove()
          ###
      ,[
        m.trust iconPark.getIcon "Export"
        "导出"
      ]

      m Box,
        isBtn:yes
        style:
          display:"flex"
          justifyContent:"center"
          alignItems:"center"
        onclick:=>
          gEData.divList.undo()
        
      ,[
        m.trust iconPark.getIcon "Undo"
      ]

      m Box,
        isBtn:yes
        style:
          display:"flex"
          justifyContent:"center"
          alignItems:"center"
        onclick:=>
          gEData.divList.redo()
        
      ,[
        m.trust iconPark.getIcon "Redo"
      ]

      if gEData.divList.presentGroup
        [
          m Box,gEData.divList.presentGroup
          m Box,
              isBtn:true
              onclick:=>
                gEData.divList.setPresentGroup ""
            ,"退出组"
        ]
        

      if gEData.divList.groupLevel > 0
        [
          m Box,"场景#{gEData.divList.groupLevel}"
          m Box,
            isBtn:true
            onclick:=>
              if gEData.divList.groupLevel - 1 >= 0
                gEData.divList.groupLevel--
          ,"上级场景"
          m Box,
            isBtn:true
            onclick:=>
              gEData.divList.groupLevel = 0
          ,"主场景"
        ]

      
    ]