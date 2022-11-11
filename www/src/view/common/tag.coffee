import Box from "./box"

export default ->
  view: (v)->
    throw Error "请使用styleExt" if v.attrs.style
    m Box,{
      style:{
        display:if v.attrs.isBlock then "block" else "inline-block"
        padding:if v.attrs.isWide then "0.2rem 1rem" else "0.2rem 0.5rem"
        fontSize:"1.3rem"
        Height:"1.8rem"
        lineHeight:"1.8rem"
        margin:"0.2rem 0.5rem"
        borderRadius:"1rem"   
        v.attrs.styleExt...
      }
      v.attrs...
    },v.children