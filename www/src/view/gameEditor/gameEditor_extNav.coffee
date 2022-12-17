import gEData from "./gameEditor_data"
import Box from "../common/box"
import Tag from "../common/tag"
import Notice from "../common/notice"
import getColor from "../help/getColor"


autoDrawExamples = [
  [
    "leftUpAngle","upEdge","rightUpAngle"
    "leftEdge","crossBlock","rightEdge"
    "leftDownAngle","downEdge","rightDownAngle"
  ]
  [
    "leftUpAngle2","crossBlock","rightUpAngle2"
    "crossBlock","crossBlock","crossBlock"
    "leftDownAngle2","crossBlock","rightDownAngle2"
  ]
]


export default ->
  view:->
    m "",
      style:
        position:"fixed"
        bottom:"2rem"
        left:"50%"
        transform:"translate(-50%, 0px)"
        #background:getColor("yellow").back
        background:"rgba(215,215,215,0.7)"
        borderRadius:"3rem"
        minWidth:"50rem"
        display:"flex"
        justifyContent:"center"
        alignItems:"center"
    ,[
      if gEData.autoDraw
        m "",
          style:
            display:"inline-flex"
            justifyContent:"center"
            alignItems:"center"
            borderRadius:"3rem"
            #background:getColor("brown").back
        ,[
          ###
          m "table",[
            gEData.autoDrawNames.map ({en,cn})=>
              m "tr",[
                m "td",[
                  m Box,
                    isBtn:yes
                    color:if gEData[en] then "deepBlue" else "green"
                    onclick: =>
                      gEData[en]=
                        x:gEData.choiseBox.x
                        y:gEData.choiseBox.y
                  ,cn + "#{if gEData[en] then "(#{gEData[en].x},#{gEData[en].y})" else ""}"
                ]
                m "td",[
                  m "img",
                    src:"./statics/cut/#{en}.png"

                ]
              ]
              
              
          ]
          ###
          if gEData.autoDrawSeletor
            m "",
              style:
                display:"grid"
                gridTemplateColumns:"1fr 1fr"
                gridGap:"1rem"
                margin:"1rem"
                
            ,[
              autoDrawExamples.map (exN,index)=>
                m "",
                  style:
                    display:"grid"
                    gridTemplateRows:"repeat(3,48px)"
                    gridTemplateColumns:"repeat(3,48px)"
                ,[
                  exN.map (mapUnit)=>
                    m "",
                      style:
                        display:"inline-flex"
                        backgroundImage:if gEData[mapUnit]
                          "url(#{gEData.tilesetUrl})"
                        else
                          "url(./statics/cut/#{mapUnit}.png)"
                        backgroundPosition:if gEData[mapUnit]
                          "-#{gEData[mapUnit].x}px -#{gEData[mapUnit].y}px"
                        cursor:"pointer"
                        width:"48px"
                        height:"48px"
                        boxSizing:"border-box"
                        transition:"transform 1s ease"
                        transform:"scale(1)"
                        boxShadow:""
                        outline:if gEData[mapUnit]
                          "0.1rem solid #{getColor("green").back}"
                        borderTop:if mapUnit.match /up/gi
                          "0.5rem dashed #{getColor("red").back}"
                        borderBottom:if mapUnit.match /down/gi
                          "0.5rem dashed #{getColor("red").back}"
                        borderLeft:if mapUnit.match /left/gi
                          "0.5rem dashed #{getColor("red").back}"
                        borderRight:if mapUnit.match /right/gi
                          "0.5rem dashed #{getColor("red").back}"
                        
                        
                      onmouseover:(e)=>
                        e.target.style.transform = "scale(1.2)"
                        e.target.style.boxShadow = "0 0 1rem rgba(0,0,0,0.3)"
                      onmouseout:(e)=>
                        e.target.style.transform = "scale(1)"
                        e.target.style.boxShadow = ""
                      onclick:=>
                        gEData[mapUnit]=
                          x:gEData.choiseBox.x
                          y:gEData.choiseBox.y
                    ,[
                      ###
                      m "",
                        style:
                          color:"#eee"
                          PointerEvents: "none"
                      ,gEData.autoDrawNames.find((item)=>item.en is mapUnit).cn
                      ###
                    ]
                    
                    
                ]

            ]

          m "",[
            m Box,
              isBtn:yes
              onclick:=>
                gEData.autoDrawSeletor = not gEData.autoDrawSeletor
            ,if gEData.autoDrawSeletor
              "收起"
            else
              "展开选择"
            m Box,
              isBtn:yes
              onclick:=>
                gEData.clearAutoDrawConfig()
            ,"清除已选"
          ]
        ]



      if gEData.divList.presentGroup
        [
          if gEData.autoDraw
            m "span",
              style:
                display:"inline-block"
                width:"0.2rem"
                background:"#aaa"
                height:"3rem"
                borderRadius:"0.5rem"
          m Box,gEData.divList.presentGroup[0..5]+"..."
          m Box,
            isBtn:true
            onclick:=>
              gEData.divList.setPresentGroup ""
              gEData.divList.cancelSelectAll()
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