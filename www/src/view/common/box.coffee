
import getColor from "../help/getColor"
###
  v.attrs.style = {}
  v.attrs.color = "red||blue||green||pink..."
###
export default ->
  data:
    value:""
  oninit:(v)->
    unless v.state.data.value
      v.state.data.value = v.attrs.value ? ""
  view: (v) ->
    _this = this
    
    m v.attrs.tagName ? "",{
      class:v.attrs.class
      style: {
        userSelect:"none" if v.attrs.isBtn
        "-webkit-user-select":"none" if v.attrs.isBtn
        display:if v.attrs.isBlock then "block" else "inline-block"
        margin:"0.5rem"
        padding:"1rem"
        background: getColor(v.attrs.color).back
        color: getColor(v.attrs.color).front
        border:"none"
        cursor:"pointer" if v.attrs.isBtn
        textAlign:"center" if v.attrs.isBtn
        boxShadow: "0 0 1rem rgba(0,0,0,0.05)" if v.attrs.hasShadow
        
        borderRadius: "1rem"
        wordWrap:"break-word"  
        v.attrs.style...

        (if v.attrs.isSwitch 
          {
            display:"inline-flex"
            alignItems:"center"
            minWidth:"4rem"
            minHeight:"2rem"
            padding:"0"
            borderRadius:"20rem"
            position:"relative"
            verticalAlign:"middle"
            transition:"background 0.5s ease"
            cursor:"pointer"
            (
              unless _this.data.value
                background:"#e1e1e1"
            )...
          }
        )...
      }
      
      (if v.attrs.isBtn 
        {
          onmouseover:(e,a)->
            @style.opacity = "0.8" if v.attrs.isBtn
            v.attrs.onmouseover? @,e,v,_this
            e.stopPropagation()
          onmouseout:(e)->
            @style.opacity = "1" if v.attrs.isBtn
            v.attrs.onmouseout? @,e,v,_this
            e.stopPropagation()
        }
      )...
      
      onclick: (e)->
        if v.attrs.isSwitch
          _this.data.value = !_this.data.value

        v.attrs.onclick? @,e,v,_this

      onchange:(e)->
        v.attrs.onchange? @,e,v,_this

      
      # 表单型属性 必须被new才可使用
      oninput: (e)->
        if (switch e.target.type
          when "text" then true
          when "textarea" then true
          when "password" then true
          when "number" then true
          )
          _this.data.value = e.target.value 
        v.attrs.oninput? @,e,v,_this
      
      (unless v.attrs.noValue
        {
          value:@data.value
        }
      )...

      #contenteditable: v.attrs.contenteditable
      #placeholder:v.attrs.placeholder
      autocomplete:"off"
      v.attrs.ext...
    }
    ,[
      if v.attrs.isSwitch
        m "",
          style:
            display:"inline-block"
            margin:"0.2rem"
            width:"1.6rem"
            height:"1.6rem"
            background:"white"
            borderRadius:"50%"
            transition:"all 0.5s ease"
            marginLeft:if _this.data.value
              "58%"
            else
              "0.2rem"
        
      v.children...
    ]