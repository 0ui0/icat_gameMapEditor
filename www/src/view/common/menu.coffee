import Box from "./box"
export default ->
  data:
    show:false
    items:[]
  oninit:({attrs})->
    if attrs.show?
      @data.show = attrs.show
  view:({attrs,children})->
    m "",[
      if @data.show
        m Box,{
          tagName:".animated.fadeIn"
          color:"white"
          style:{
            display:"flex"
            flexDirection:"column"
            padding:0
            boxShadow:"0 0 1rem rgba(0,0,0,0.3)"
            attrs.style...
          }
          oncreate:({dom})=>
            document.addEventListener "click",fnClick = =>

              @data.show = false
              document.removeEventListener "click",fnClick
              m.redraw()

              
          attrs.ext...
        }
        ,[
          children...
        ]
    ]