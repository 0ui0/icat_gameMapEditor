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
  cancelSelect:()->
    @hasBorder = 0
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
  show:()->
    @hideState = false
  lock:()->
    @lockState = true
  unlock:()->
    @lockState = false
  hideOrShow:->
    @hideState = not @hideState
  lockOrUnlock:->
    @lockState = not @lockState
    
  check:->
    @checked = true
  unCheck:->
    @checked = false
  inverse:->
    @checked = not @checked
  
  


  
  

    
    
    
    

    
  



