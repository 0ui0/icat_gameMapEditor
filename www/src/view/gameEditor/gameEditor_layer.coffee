import Box from "../common/box"
import Tag from "../common/tag"
import gEData from "./gameEditor_data"
import getColor from "../help/getColor"

DivItem = ->
  showChild = false
  view:({attrs})->
    preDiv = attrs.preDiv
    children = gEData.divList.data.filter((preDiv)=>preDiv.linkid is attrs.preDiv.id)
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
        gridColumnStart:if preDiv.isGroup then 1
        gridColumnEnd:if preDiv.isGroup then 5
        boxShadow:"0 0 0.5rem rgba(0,0,0,0.2)"
        borderRadius:"0.3rem"
      ext:
        onclick:(e)=>
          fn = (preDiv)=>
            preDiv.check()

            children = gEData.divList.data.filter (preDiv1)=> preDiv1.linkid is preDiv.id
            if children.length > 0
              children.forEach (child)=>
                fn(child)
          fn(preDiv)
          e.stopPropagation()
    ,[
      m "",[
        (if preDiv.isGroup then "组：" else "")
        #preDiv.x + " " + preDiv.y
        preDiv.id[0..2]
        if preDiv.hideState then "[藏]" else ""
        if preDiv.lockState then "[锁]" else ""
      ]
      if preDiv.isGroup and children.length > 0
        m Tag,
          isBtn:true
          ext:
            onclick:(e)=>
              showChild = !showChild
              e.stopPropagation()
        ,if showChild then "=" else "+"
      if showChild is true
        m "",
          style:
            display:"grid"
            gridTemplateColumns:"auto auto auto"
          
        ,[
          children.map (preDiv)=>
            m DivItem,
              preDiv:preDiv
        ]
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
      m "",
        style:
          position:"sticky"
          top:0
          background:"rgba(255,255,255)"
      ,[
        gEData.layer.menu.map (item,index)=>
          m "",
            style:
              display:"inline-block"
              margin:"1rem"
              fontSize:if index is gEData.layer.selected then "1.8rem" else "1.6rem"
              color:"#aaa"
              cursor:"pointer"
              transition:"0.5s all ease"
            onclick:=>
              gEData.layer.selected = index

          ,item.name

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
        ]  if gEData.layer.selected is 0

      ]

      if gEData.layer.selected is 0
        m ".animated.fadeIn",
          style:
            display:"grid"
            gridTemplateColumns:"auto auto auto"

            flexWrap:"wrap"
            background:"#fff"
        ,[
          gEData.divList.data.filter((preDiv)=>preDiv.linkid is 0 or not preDiv.linkid).sort((x1,x2)=>x1-x2).map (preDiv)=>

            m DivItem,
              preDiv:preDiv

        ]
    ]