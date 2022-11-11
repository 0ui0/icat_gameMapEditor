import Box from "./box"
import getColor from "../help/getColor"


export default (obj)->
  checkType arguments,["object"],"Comp(obj) in notice.coffee"

  confirm = obj.confirm ? =>
  cancel = obj.cancel ? =>
  confirmWords = obj.confirmWords ? "确定"
  cancelWords = obj.cancelWords ? "取消"
  content = obj.content ? undefined
  comp = obj.comp ? undefined 
  hideBtn = obj.hideBtn ? 0
  contentAttrs = obj.contentAttrs ? {}
  tip = obj.tip ? "提示"
  msg = obj.msg ? "没有传入提示消息哦！"
  type = obj.type ? "peace"
  sign = obj.sign ? Date.now()
  

  return
    onbeforeremove:({dom,attrs})->
      dom.classList.add "bounceOut"
      return new Promise (res,rej)=>
        setTimeout =>
          attrs.closeLayer()
          m.redraw()
          res()
        ,700
    sign:sign
    data:
      confirm:confirm
      confirmWords:confirmWords
      cancel:cancel
      cancelWords:cancelWords
      tip:tip
      msg:msg
      content:content
      comp:comp
      hideBtn:hideBtn
      contentAttrs:contentAttrs
      type:type

    oninit:({attrs})->
      #安装delete方法使得可以通过组件内部关闭
      @data.contentAttrs.delete = attrs.delete
      @data.contentAttrs.closeLayer = attrs.closeLayer
    view:({attrs})->
      if comp
        m comp,contentAttrs
      else
        m "",[
          m Box,
            class: switch @data.type
              when "basic" then "animated shake"
              when "peace" then "animated pulse"
            style:
              border:"1px solid #727C88"
              padding:"0 0.5rem"
              maxWidth:"100vw"
              width:"max-content"
              boxSizing:"border-box"
              display: "grid"
              margin:"1rem auto"
              boxShadow:"0 0 2rem rgba(0,0,0,0.2)"
              borderRadius:"1rem"
              overflow:"hidden"
              gridTemplateAreas: """
              "x x"
              "a a"
              "b c"
              """
            color: "white"
          ,[
            # 如果有组件传入，直接展示组件

            #关闭小圈
            m "",
              style:
                gridArea:"x"
                display:"flex"
                alignItems:"center"
                justifyContent:"center"
                background:getColor("grey").back
                borderRadius:"0 0 1rem 1rem"
                marginBottom:"0.5rem"
            ,[
              m Box,
                isBtn:true
                onclick:=> attrs.delete()
                style:
                  padding:0
                  border:0
                  display:"inline-block"
                  width:"1.2rem"
                  height:"1.2rem"
                  background:getColor("red").back
                  borderRadius:"3rem"
                  
              m "",
                style:
                  flex:1
                  display:"flex"
                  justifyContent:"center"
                  alignItems:"center"
              ,[
                m "span",
                  style:
                    fontWeight:"bold"
                ,@data.tip
              ]
            ]

            if @data.content
              m "",
                style:
                  gridArea:"a"
              ,[
                m @data.content,@data.contentAttrs
              ]
                
            else
              m Box,
                style:
                  gridArea:"a"
              ,[
                m "",@data.msg
              ] 


            if hideBtn is 0 or hideBtn is 3
              #确定
              m Box,
                color:"red"
                style:
                  gridArea:"b"
                isBtn: yes
                onclick: (e)=>
                  if (await @data.confirm(e,attrs.delete,@data)) is undefined
                    attrs.delete()
              ,@data.confirmWords
            else
              m "",""

            if hideBtn is 0 or hideBtn is 2
              #取消
              m Box,
                style:
                  gridArea:"c"
                isBtn: yes
                onclick: (e)=>
                  if (await @data.cancel(e,attrs.delete,@data)) is undefined
                    attrs.delete()
              ,@data.cancelWords
            else
              m "",""
          ]
        ]