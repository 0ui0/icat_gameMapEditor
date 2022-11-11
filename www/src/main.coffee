

import GameEditor from "./view/gameEditor/gameEditor_main"
import mithril from "mithril"
import * as iconPark from "@icon-park/svg"
import initResize from "./initResize"

import checkType_ from  "icat_checktype"


window.checkType = checkType_
window.m = mithril
window.iconPark = {
  iconPark...
}
window.iconPark.getIcon = (name,config)->    
    return iconPark[name]({
      theme: 'multi-color'
      size: '1.8rem'
      strokeWidth: 5
      strokeLinecap: 'round'
      strokeLinejoin: 'round'
      fill:['#594f4c' ,'#ffdb66' ,'#594f4c' ,'#dd7263']
      config...
    })

initResize()

do ->
  m.route document.querySelector("#home"),"/gameEditor"
    ,
      "/gameEditor":
        render:->
          m GameEditor


  # 注意render和view的区别，如果使用render，那么layout不会在路由更改的时候重新渲染
