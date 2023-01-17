import gEData from "./gameEditor_data"
import Box from "../common/box"
import Tag from "../common/tag"
import Notice from "../common/notice"


barWidth = 0
calcBarWidth = (dom)->
  barWidth = getComputedStyle(dom).width.replace("px","")*1

presentHover = ""

urlList = [
  {
    name:"操作(A)"
    url:"#"
    icon:"arrow"
    sizeRate:1
    power:1
  }
  {
    name:"绘图(P)"
    url:"#"
    icon:"pen"
    sizeRate:1
    power:1
  }
  {
    name:"填充(F)"
    url:"#"
    icon:"paint"
    sizeRate:1
    power:1
  }
  {
    name:"自动元件"
    url:"#"
    icon:"autoUnit"
    sizeRate:1
  }
  {
    name:"清除"
    url:"#"
    icon:"dustbin"
    sizeRate:1
    power:1
  }
  {
    name:"配置"
    url:"#"
    icon:"setting2"
    sizeRate:1
    power:1
  }
  {
    name:"导出"
    url:"#"
    icon:"export"
    sizeRate:1
    power:1
  }
  {
    name:"存档"
    url:"#"
    icon:"save"
    sizeRate:1
    power:1
  }
  {
    name:"导入"
    url:"#"
    icon:"import"
    sizeRate:1
    power:1
  }
  
  {
    name:"撤销"
    url:"#"
    icon:"undo"
    sizeRate:1
    power:1
  }
  {
    name:"重做"
    url:"#"
    icon:"redo"
    sizeRate:1
    power:1
  }
 

]





export default
  oninit:->
  oncreate:({dom})->
    calcBarWidth(dom)
  onupdate:({dom})->
    calcBarWidth(dom)

  view:(v)->

    m "",
      style:
        display:"flex"
        position:"fixed"
        flexDirection:"column"
        justifyContent:"center"
        alignItems:"center"
        right:"3rem"
        top:"50%"
        transform:"translate(0,-50%)"
        zIndex:999
    ,[
      m "",
        style:
          display:"flex"
          flexDirection:"column"
          alignItems:"center"
          backgroundColor:"rgba(215,215,215,0.7)"
          #backgroundImage:"url(./statics/nav_bg.png)"
          backgroundRepeat:"no-repeat"
          backgroundSize:"100% auto"
          backgroundPosition:"bottom"

          borderRadius:"2rem"
          #height:if Mob then "80vw" else "auto"
          #height:if Mob then "6rem" else "7rem"
          padding:"1rem 0"
          #marginBottom:"0.5rem"

          #border:"0.1rem solid #909090"
          backdropFilter: "blur(10px)"
          "-webkit-backdrop-filter": "blur(10px)"
          transition:"all ease 1s"
          #boxShadow:"0 0 1rem rgba(0,0,0,0.4)"

      ,[
        m "",
          style:
            display:"flex"
            justifyContent:"center"
            alignItems:"center"
            height:"100%"
          ,[
            m "img[src=/statics/back2.png]",
              style:
                marginLeft:"1rem"
                marginRight:"1rem"
                height:"3rem"
                cursor:"pointer"
                transition:"all 0.5s"
              title:"返回"
              onmouseover:(e)=>
                e.target.style.transform = "scale(1.2)"
              onmouseout:(e)=>
                e.target.style.transform = "scale(1)"
              onclick:->
                ROUTE.back()
          ]
        m "",
          style:
            display:"flex"
            flexDirection:"column"
            justifyContent:"space-evenly"
            alignItems:"center"
            width:"100%"
        ,[
          for item,index in urlList
            do(item,index)->
              m ".animated.bounceIn",
                style:
                  display:"flex"
                  flexDirection:"column"
                  justifyContent:"center"
                  alignItems:"center"
                  position:"relative"
                  width:if not m.route.get().match("home") and item.url is "/plus"
                      "1%"
                    else
                      "100%"
                  transition:"width 1s ease"
                onbeforeremove:(v)->
                  v.dom.classList.add("bounceOut")
                  return new Promise (res,rej)->
                    #v1.dom.addEventListener "animationend",res
                    setTimeout ->
                      res()
                    ,700
                onmouseover:(e)=>
                  urlList.forEach (item)=>item.sizeRate = 0.8
                  urlList[index-1]?.sizeRate = 1
                  urlList[index+1]?.sizeRate = 1
                  urlList[index-2]?.sizeRate = 0.9
                  urlList[index+2]?.sizeRate = 0.9
                  urlList[index].sizeRate = 1.15
                  presentHover = item.name
                onmouseout:(e)=>
                  urlList.forEach (item)=>item.sizeRate = 1
                  presentHover = ""
              ,[

                m "",
                  style:
                    display:"inline-block"
                    position:"relative"
                    #margin:if !Mob then "0 3.5rem"
                    margin:"0.5rem 2rem"
                ,[
                  m "img[src=/statics/navbar/#{item.icon}.svg]",
                    title:item.name
                    style:
                      display:"relative"
                      width:if not m.route.get().match("home") and item.url is "/plus"
                        "0rem"
                      else
                        if Mob then "#{3.5*item.sizeRate}rem" else "#{4*item.sizeRate}rem"
                      height:if Mob then "#{3.5*item.sizeRate}rem" else "#{4*item.sizeRate}rem"
                      ###
                      transform:"translateZ(0) #{
                        if editorData.show is true and item.url is "/plus"
                          "rotate(225deg)"
                        else
                          ""
                      }"
                      ###
                      cursor:"pointer"
                      transition:"all 0.5s"

                    onclick:(e)=>
                      switch item.name
                        when "操作(A)"
                          gEData.mouseState = "mouse"
                        when "绘图(P)"
                          gEData.mouseState = "pen"
                        when "填充(F)"
                          gEData.divList.fillRect()
                        when "清除"
                          gEData.divList.delSelectedItems()
                        when "配置"
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
                            

                        when "导出"
                          gEData.divList.export()
                        when "撤销"
                          gEData.divList.undo()
                        when "重做"
                          gEData.divList.redo()
                        when "自动元件"
                          gEData.autoDraw = not gEData.autoDraw
                        when "存档"
                          gEData.divList.save()
                        when "导入"
                          gEData.divList.import()
      
                  #小红点
                  if gEData.mouseState is "mouse" and item.name is "操作(A)" or 
                    gEData.mouseState is "pen" and item.name is "绘图(P)" or
                    gEData.autoDraw and item.name is "自动元件"
                      m "",
                        style:
                          position:"absolute"
                          right:"-0.5rem"
                          top:"-0.5rem"
                          width:"1.2rem"
                          height:"1.2rem"
                          background:"#DD7263"
                          borderRadius:"50%"
                  
                ]



                #指示条
                m "",
                  style:
                    position:"absolute"
                    left:"-4rem"
                    display: "block"
                    marginTop:"0.5rem"
                    height:if presentHover is item.name
                      "2rem"
                    else
                      "0"
                    width:if presentHover is item.name
                      "5rem"
                    else
                      "0"
                    background:"rgba(0,0,0,0.5)"
                    borderRadius:"1rem"
                    transition:"all 0.6s"
                    textAlign:"center"
                    display:"flex"
                    justifyContent:"center"
                    alignItems:"center"
                    transform:"scale(0.8)"
                ,[
                  if presentHover is item.name
                    m "span",
                      oninit:(e)->
                        setTimeout =>
                          e.dom.style.opacity = 1
                        ,200
                      style:
                        opacity:0
                        transition:"all 1s"
                        fontSize:"1rem"
                        lineHeight:"2rem"
                        color:"white"
                    ,item.name
                ]

              ]

        ]


      ]
    ]
