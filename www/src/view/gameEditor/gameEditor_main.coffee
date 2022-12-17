import gEData from "./gameEditor_data"
import Left from "./gameEditor_left"
import Right from "./gameEditor_right"
import Box from "../common/box"
import Tag from "../common/tag"
#import html2canvas from 'html2canvas'
import getColor from "../help/getColor"
import Notice from "../common/notice"
import gENav from "./gameEditor_nav"
import gEExtNav from "./gameEditor_extNav"




export default ->
  oninit:=>
    gEData.initRightMenu()

    document.addEventListener "keydown",(e)->
      gEData.downkeys.push (e.keyCode)

      if gEData.downkeys[0] is 8 or gEData.downkeys[0] is 46 #删除
        gEData.divList.delSelectedItems()


      if (gEData.downkeys[0] is 91 or gEData.downkeys[0] is 93) and gEData.downkeys[1] is 67 #复制
        gEData.divList.copySelectedItems()
        
      if (gEData.downkeys[0] is 91 or gEData.downkeys[0] is 93) and gEData.downkeys[1] is 86 #粘贴
        gEData.divList.pasteCopyedItems()
      
      if (gEData.downkeys[0] is 91 or gEData.downkeys[0] is 93) and gEData.downkeys[1] is 90 #撤销
        gEData.divList.undo()

      if gEData.downkeys[0] is 18 and gEData.downkeys[1] is 71 #编组
        gEData.divList.becomeGroup()
      if gEData.downkeys[0] is 18 and gEData.downkeys[1] is 16 and gEData.downkeys[2] is 71 #拆散
        gEData.divList.exitGroup()

      if (gEData.downkeys[0] is 91 or gEData.downkeys[0] is 93) and
        gEData.downkeys[1] is 16 and
        gEData.downkeys[2] is 90 #重做

          gEData.divList.redo()

      if gEData.downkeys[0] is 65 #删除
        gEData.mouseState = "mouse"

      if gEData.downkeys[0] is 80
        gEData.mouseState = "pen"

      if gEData.downkeys[0] is 70 #填充
        gEData.divList.fillRect()

      m.redraw()
      console.log gEData.downkeys
    document.addEventListener "keyup",(e)->
      gEData.downkeys = []
      console.log gEData.downkeys
  view:->
    m "",
      style:
        a:12
        #background:getColor("green").back
    ,[
      m Notice
      
      m "",
        style:
          display:"flex"
          background:"#fff"
      ,[
        m Left
        m Right
      ]

      m "",
        style:
          position:"fixed"
          right:0
          top:0
      ,[
        m "",
          style:
            margin:"3rem"
            fontSize:"2rem"
            color:"#ccc"
        ,[
          "X：#{gEData.pen.x}"
          m "br"
          "y：#{gEData.pen.y}"
        ]
        
      ]


      m gENav
      m gEExtNav
    ]