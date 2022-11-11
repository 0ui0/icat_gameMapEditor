import Menu from "../common/menu"
import DivList from "./gameEditor_divList"


export default
  downkeys:[]

  leftWidth:"30"
  leftHeight:"40"

  autoDrawNames:[
    {en:"crossBlock",cn:"内块"}
    {en:"upEdge",cn:"上边"}
    {en:"downEdge",cn:"下边"}
    {en:"leftEdge",cn:"左边"}
    {en:"rightEdge",cn:"右边"}
    {en:"leftUpAngle",cn:"左上角"}
    {en:"rightUpAngle",cn:"右上角"}
    {en:"leftDownAngle",cn:"左下角"}
    {en:"rightDownAngle",cn:"右下角"}
    {en:"leftUpAngle2",cn:"左上交角"}
    {en:"rightUpAngle2",cn:"右上交角"}
    {en:"leftDownAngle2",cn:"左下交角"}
    {en:"rightDownAngle2",cn:"右下交角"}
  
  ]

  clearAutoDrawConfig:->
    @autoDrawNames.forEach ({en,cn})=>
      @[en] = null


  crossBlock:
    x:48
    y:48
  upEdge:
    x:48
    y:0
  downEdge:
    x:48
    y:96
  leftEdge:
    x:0
    y:48
  rightEdge:
    x:96
    y:48
  leftUpAngle:
    x:0
    y:0
  rightUpAngle:
    x:96
    y:0
  leftDownAngle:
    x:0
    y:96
  rightDownAngle:
    x:96
    y:96
  leftUpAngle2:
    x:192
    y:0
  rightUpAngle2:
    x:288
    y:0
  leftDownAngle2:
    x:192
    y:96
  rightDownAngle2:
    x:288
    y:96


  getBoxXFl:(x)-> Math.floor(x/@getW())*@getW()
  getBoxYFl:(y)-> Math.floor(y/@getH())*@getH()
  getBoxXCe:(x)-> Math.ceil(x/@getW())*@getW()
  getBoxYCe:(y)-> Math.ceil(y/@getH())*@getH()
  
  
  getBoxX:(x)-> Math.round(x/@getW())*@getW()
  getBoxY:(y)-> Math.round(y/@getH())*@getH()
  getBoxW:(x1,x2)-> Math.round(Math.abs(x2-x1)/@getW())*@getW()
  getBoxH:(y1,y2)-> Math.round(Math.abs(y2-y1)/@getH())*@getH()

  mouseState:"pen"
  autoDraw:false

  tilesetUrl:"statics/green/tileset/tukuai.png"
  
  tileset:null
  tilesets:[
    "statics/green/tileset/01.png"
  ]

  canvasHeight:1000
  canvasWidth:1000

  mouseDirection:true

  basicSize:
    w:48
    h:48
  getW:-> @basicSize.w 
  getH:-> @basicSize.h
  choiseBox:
    x:0
    y:0
    w:48
    h:48
  pen:
    show:false
    x:0
    y:0
    texture:null

  choiseBox2:
    x:0
    y:0
    w:0
    h:0

  RightMenu:null
  initRightMenu:->
    @RightMenu ?= new Menu()

  rightMenuTop:0
  rightMenuLeft:0

  divList:new DivList()

