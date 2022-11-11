import PreDiv from "./gameEditor_preDiv"
import gEData from "./gameEditor_data"
import {v4 as uuid} from "uuid"

export default DivList = class
  constructor:(obj={
    data:[]
    groups:[]
    groupLevel:0
    copy:[]
  })->
    for [key,value] in Object.entries obj
      @[key] = value
  findById:(id)->
    @data.find (preDiv)=> preDiv.id is id
  add:(preDiv)->
    unless preDiv instanceof PreDiv
      throw new Error "添加的元素不是PreDiv的实例"
    preDiv.divList = @
    @data.push preDiv
  
  addNoRepeat:(preDiv)->
    unless preDiv instanceof PreDiv
      throw new Error "添加的元素不是PreDiv的实例"
    unless @checkSameSiteRepeat preDiv
      @add preDiv
  addNoRepeatAutoDraw:(preDiv)->
    unless preDiv instanceof PreDiv
      throw new Error "添加的元素不是PreDiv的实例"


    unless (@data.find (item)=>
      preDiv.x is item.x and
      preDiv.y is item.y and
      not @findInGroup item
    )
      @add preDiv
    
  checkSameSiteRepeat:(preDiv)->
    unless preDiv instanceof PreDiv
      throw new Error "添加的元素不是PreDiv的实例"
    samePreDivs = @data.find (item)=>

      preDiv.x is item.x and
      preDiv.y is item.y and
      preDiv.imgX is item.imgX and
      preDiv.imgY is item.imgY and
      preDiv.url is item.url and
      preDiv.imgW is item.imgW and
      preDiv.imgH is item.imgH

    if samePreDivs
      samePreDivs
    else
      null

  getSelectedItems:->
    @data.filter (preDiv)=> preDiv.hasBorder

  delSelectedItems:->
    @getSelectedItems().forEach (preDiv)=>
      preDiv.del()

  translateSelectedItems:(deltaX,deltaY)->
    checkType arguments,["number","number"],"gameEditor.DivList.translateSelectedItem()"
    @getSelectedItems().forEach (preDiv)=>
      preDiv.x += deltaX
      preDiv.y += deltaY
  setXYSelectedItems:(x,y)->
    checkType arguments,["number","number"],"gameEditor.DivList.translateSelectedItem()"
    @getSelectedItems().forEach (preDiv)=>
      preDiv.x = x
      preDiv.y = y
  changeZIndexSelectedItems:(deltaZIndex)->
    checkType arguments,["number"],"gameEditor.DivList.changeZIndexSelectedItem()"
    @getSelectedItems().forEach (preDiv)=>
      preDiv.zIndex += deltaZIndex
  resetZIndexSelectedItems:(zIndex)->
    checkType arguments,["number"],"gameEditor.DivList.resetZIndexSelectedItem()"
    @getSelectedItems().forEach (preDiv)=>
      preDiv.zIndex = zIndex

  becomeGroup:->
    selectedItems = @getSelectedItems()

    sameGroup = @groups.find (group)=>
      tmp1 = group.every (item1)=>
        selectedItems.some (item2)=>
          item1 is item2
      tmp2 = selectedItems.every (item1)=>
        group.some (item2)=>
          item1 is item2
      tmp1 and tmp2

    return if sameGroup #已经有相同的组，不需要再编组
    @groups.push selectedItems
  
  findInGroup:(preDiv)->
    unless preDiv instanceof PreDiv
      throw new Error "要查找所属组的元素不是PreDiv的实例"

    #查找元素所在的组，一个元素可以同时在多个组里

    inGroups = @groups.filter (group)=>
      group.find (item)=> preDiv is item

    if inGroups?.length > 0
      inGroups = inGroups.sort (x1,x2)=> x2.length - x1.length
      return inGroups[@groupLevel] #按双击的层级返回
    else
      return null

  exitGroup:->
    @getSelectedItems().forEach (preDiv)=>
      group = @findInGroup preDiv
      groupIndex = @groups.indexOf group
      @groups.splice groupIndex,1

  getInRect:(gEData)-> #获取被框选元素
    checkType arguments,["object"],"DivList.getInRect()"
    @data.filter (preDiv)=>
      if ((  gEData.choiseBox2.x < preDiv.x < gEData.choiseBox2.x + gEData.choiseBox2.w ) and
      ( gEData.choiseBox2.y < preDiv.y < gEData.choiseBox2.y + gEData.choiseBox2.h)) or
      ((  gEData.choiseBox2.x < preDiv.x + preDiv.w < gEData.choiseBox2.x + gEData.choiseBox2.w ) and
      ( gEData.choiseBox2.y < preDiv.y < gEData.choiseBox2.y + gEData.choiseBox2.h)) or
      ((  gEData.choiseBox2.x < preDiv.x < gEData.choiseBox2.x + gEData.choiseBox2.w ) and
      ( gEData.choiseBox2.y < preDiv.y + preDiv.h < gEData.choiseBox2.y + gEData.choiseBox2.h)) or
      (( gEData.choiseBox2.x < preDiv.x + preDiv.w < gEData.choiseBox2.x + gEData.choiseBox2.w) and
      ( gEData.choiseBox2.y < preDiv.y + preDiv.h < gEData.choiseBox2.y + gEData.choiseBox2.h))
        return true
      else
        return false

  copySelectedItems:->
    @copy = @getSelectedItems().map (preDiv)=>
      preDiv.hasBorder = 0
      div = new PreDiv {
        preDiv...
        x:preDiv.x + gEData.getW()
        y:preDiv.y + gEData.getH()
        id:uuid()
        hasBorder:1
      }
      div.divList = @
      return div
    console.log "copy",@copy

  pasteCopyedItems:->
    @copy = @copy.map (preDiv)=>
      preDiv.hasBorder = 0
      div = new PreDiv {
        preDiv...
        x:preDiv.x + gEData.getW()
        y:preDiv.y + gEData.getH()
        id:uuid()
        hasBorder:1
      }
      div.divList = @
      return div
      

    @data = [
      @data...
      @copy...
    ]
    console.log @data

  fillRect:->
    @data.forEach (item)=>
      item.cancelSelect()
    if gEData.choiseBox2.w > 0 or gEData.choiseBox2.h > 0
      gEData.choiseBox2.x =  gEData.getBoxX gEData.choiseBox2.x
      gEData.choiseBox2.y = gEData.getBoxY gEData.choiseBox2.y
      gEData.choiseBox2.w = gEData.getBoxX gEData.choiseBox2.w
      gEData.choiseBox2.h = gEData.getBoxY gEData.choiseBox2.h
      
    preObjs = []

    xNum = Math.floor gEData.choiseBox2.w / gEData.choiseBox.w
    yNum = Math.floor gEData.choiseBox2.h / gEData.choiseBox.h
    xRest = gEData.choiseBox2.w % gEData.choiseBox.w
    yRest =  gEData.choiseBox2.h % gEData.choiseBox.h
    allNum = xNum * yNum + xRest * yRest

    for xIndex in [0...xNum]
      for yIndex in [0...yNum]
        tmp = new PreDiv
          id:Date.now()
          x:gEData.choiseBox2.x + xIndex * gEData.choiseBox.w
          y:gEData.choiseBox2.y + yIndex * gEData.choiseBox.h
          imgX:gEData.choiseBox.x
          imgY:gEData.choiseBox.y
          imgW:gEData.choiseBox.w
          imgH:gEData.choiseBox.h
          url:gEData.tilesetUrl
          hasBorder:2

        @add new PreDiv tmp
    @becomeGroup()
          




    

  
