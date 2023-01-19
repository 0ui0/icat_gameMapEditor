import {v4 as uuid} from "uuid"
import gEData from "./gameEditor_data"

export default class
  constructor:(obj = {
    id:uuid()
    x:0
    y:0
    autoType:null
    autoMain:false
    imgX:0
    imgY:0
    imgW:gEData.getW()
    imgH:gEData.getH()
    url:""
    hasBorder:0
    zIndex:1
    linkid:""
    hideState:false
    lockState:false
    checked:false
    isGroup:false
  })->
    obj.id = uuid()

    for [key,value] in Object.entries obj
      @[key] = value

    if obj.divList
      @divList = obj.divList
      
  changeId:(newId)->
    checkType arguments,["string"],"gameEditor.PreDiv.changeId()"
    @id = newId

  del:->
    @divList.data = @divList.data.filter (preDiv)=>
      preDiv.id isnt @id
  select:(level)-> #选中
    @hasBorder = level
    unless @lockState or @hideState
      @checked = true
  cancelSelect:()->
    @hasBorder = 0
    unless @lockState or @hideState
      @checked = false
  setZIndex:(zIndex)->
    checkType arguments,["number"],"gameEditor.DivList.setZIndex()"
    @zIndex = zIndex
  zIndexIncrease:->
    @zIndex += 5
  zIndexDecrease:->
    @zIndex -= 5
  copy:->
    copyDiv = {
      @...
    }
    copyDiv.id = uuid()
    copyDiv.x += gEData.getW()
    copyDiv.y += gEData.getH()
    @divList.add copyDiv
  linkTo:(linkid)->
    checkType arguments,["string"],"gameEditor.PreDiv.linkTo()"
    @linkid = linkid

  hide:()->
    @hideState = true
    @hasBorder = 0
  show:()->
    @hideState = false
    if @checked
      @hasBorder = if @isGroup then 2 else 1
  lock:()->
    @lockState = true
    @hasBorder = 0
  unlock:()->
    @lockState = false
    if @checked
      @hasBorder = if @isGroup then 2 else 1
  hideOrShow:->
    if @hideState
      @show()
    else
      @hide()
  lockOrUnlock:->
    if @lockState
      @unlock()
    else
      @lock()
    
  check:->
    @checked = true
    unless @lockState or @hideState
      @hasBorder =  if @isGroup then 2 else 1
    
  unCheck:->
    @checked = false
    unless @lockState or @hideState
      @hasBorder = 0

  inverse:->
    if @checked
      @unCheck()
    else
      @check()
  
  


  
  

    
    
    
    

    
  



