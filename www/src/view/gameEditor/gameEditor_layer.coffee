import Box from "../common/box"
import Tag from "../common/tag"
import gEData from "./gameEditor_data"
import getColor from "../help/getColor"

DivItem = ->
  view:({attrs})->
    preDiv = attrs.preDiv
    m Box,
      isBtn:yes
      color:if preDiv.isGroup then "yellow"
      style:
        margin:"0.2rem"
        padding:"0.5rem 1rem"
        borderRadius:"0.2rem"
        border:if preDiv.hasBorder is 1
          "0.2rem solid #{getColor("yellow").back}"
        else if preDiv.hasBorder is 2
          "0.2rem solid #{getColor("green").back}"
        outline:if preDiv.checked
          "0.2rem solid red"
      ext:
        onclick:(e)=>
          fn = (preDiv)=>
            preDiv.inverse()
            children = gEData.divList.data.filter (preDiv1)=> preDiv1.linkid is preDiv.id
            if children.length > 0
              children.forEach (child)=>
                fn(child)
          fn(preDiv)
          e.stopPropagation()
    ,[
      m "",[
        (if preDiv.isGroup then "组：" else "")+preDiv.x + " " + preDiv.y
        if preDiv.hideState then "[藏]" else ""
        if preDiv.lockState then "[锁]" else ""
      ]
      gEData.divList.data.filter((preDiv)=>preDiv.linkid is attrs.preDiv.id).map (preDiv)=>
        m DivItem,
          preDiv:preDiv
    ]


export default ->

  

  view:->

    m "",
      style:
        overflow:"auto"
      onclick:=>
        gEData.divList.data.forEach (preDiv)=>
          preDiv.unCheck()

    ,[
      m "",[
        m "",
          style:
            display:"inline-block"
            margin:"1rem"
            fontSize:"1.8rem"
            color:"#aaa"
        ,"图层"

        m "",
          style:
            display:"inline-block"
            margin:"1rem"
            fontSize:"1.8rem"
            color:"#aaa"
        ,"地图"

        m "",[
          m Tag,
            isBtn:yes
            color:"yellow"
            ext:
              onclick:(e)=>
              
                gEData.divList.getCheckedItems().forEach (preDiv)=>
                  preDiv.lockOrUnlock()

                e.stopPropagation()
          ,"锁定/解锁"

          m Tag,
            isBtn:yes
            color:"red"
            ext:
              onclick:(e)=>
                gEData.divList.hideOrShowCheckedItems()
                e.stopPropagation()
          ,"隐藏/显示"
        ]

      ]

      m "",
        style:
          display:"flex"
          flexWrap:"wrap"
          background:"#fff"
      ,[
        gEData.divList.data.filter((preDiv)=>preDiv.linkid is 0 or not preDiv.linkid).sort((x1,x2)=>x1-x2).map (preDiv)=>
          m DivItem,
            preDiv:preDiv
      ]
    ]