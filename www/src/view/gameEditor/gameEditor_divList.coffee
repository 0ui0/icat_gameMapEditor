import PreDiv from "./gameEditor_preDiv"
import gEData from "./gameEditor_data"
import Notice from "../common/notice"
import {v4 as uuid} from "uuid"

export default DivList = class
  constructor:(obj={
    data:[]
    historyDatas:[]
    cursor:-1
    groups:[]
    groupLevel:0
    copy:[]
    group:[]
    presentGroup:""
    showZIndex:false
    showZIndexTimer:null
  })->
    for [key,value] in Object.entries obj
      @[key] = value
  
  findById:(id)->
    checkType arguments,["string"],"gameEditor.DivList.findById()"
    @data.find (preDiv)=> preDiv.id is id

  add:(preDiv,noRecord)->
    
    unless preDiv instanceof PreDiv
      throw new Error "添加的元素不是PreDiv的实例"
    preDiv.divList = @
    preDiv.zIndex = @data.length
    if @presentGroup
      preDiv.linkid = @presentGroup 
    @data.push preDiv

    @record() unless noRecord #不要记录
  
  record:()->
    if @historyDatas.length isnt @cursor + 1
      @historyDatas.length = @cursor + 1

    copyData = @data.map (preDiv)=>
      new PreDiv {
        preDiv...
      }
    
    #id映射
    idMap = {}
    @data.forEach (preDiv,index)=>
      idMap[preDiv.id] = copyData[index].id

    #根据映射表修改linkid
    copyData.forEach (preDiv,index)=>
      preDiv.linkid = idMap[preDiv.linkid] or ""      
    copyData.presentGroup = @presentGroup

    @historyDatas.push copyData
    @cursor++


  undo:()->
    if @cursor - 1 > -1
      @cursor--
      @data = [@historyDatas[@cursor]...]
      @presentGroup = @historyDatas[@cursor].presentGroup
    else
      @data = []
      @cursor = -1



  redo:()->
    if @cursor + 1 <= @historyDatas.length - 1
      @cursor++
      @data = [@historyDatas[@cursor]...]
      @presentGroup = @historyDatas[@cursor].presentGroup
  
  addNoRepeat:(preDiv)->
    unless preDiv instanceof PreDiv
      throw new Error "添加的元素不是PreDiv的实例"
    unless @checkSameSiteRepeat preDiv
      @add preDiv

  addNoRepeatAutoDraw:(preDiv)->
    unless preDiv instanceof PreDiv
      throw new Error "添加的元素不是PreDiv的实例"


    unless (@data.find (item)=>
      preDiv.x is item.x and preDiv.y is item.y and (not item.linkid or item.linkid is @presentGroup)
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
    @data.filter (preDiv)=> preDiv.hasBorder and !preDiv.hideState and !preDiv.lockState
  getCheckedItems:->
    @data.filter (preDiv)=> preDiv.checked

  delSelectedItems:->
    @getSelectedItems().forEach (preDiv)=>
      preDiv.del()
    @record()

  translateSelectedItems:(deltaX,deltaY)->
    checkType arguments,["number","number"],"gameEditor.DivList.translateSelectedItem()"
    @getSelectedItems().forEach (preDiv)=>
      preDiv.x += deltaX
      preDiv.y += deltaY
    #@updateGroup() #太卡了，剪切到到移动结束部分运行

  setXYSelectedItems:(x,y)->
    checkType arguments,["number","number"],"gameEditor.DivList.translateSelectedItem()"
    @getSelectedItems().forEach (preDiv)=>
      preDiv.x = x
      preDiv.y = y
    @record()

  changeZIndexSelectedItems:(deltaZIndex)->
    checkType arguments,["number"],"gameEditor.DivList.changeZIndexSelectedItem()"
    @showZIndex = true
    @showZIndexTimer = clearTimeout @showZIndexTimer
    @showZIndexTimer = setTimeout =>
      @showZIndex = false
      m.redraw()
    ,1000
    @getSelectedItems().forEach (preDiv)=>
      if preDiv.zIndex + deltaZIndex > 0
        preDiv.zIndex += deltaZIndex
    @record()

  resetZIndexSelectedItems:(zIndex)->
    checkType arguments,["number"],"gameEditor.DivList.resetZIndexSelectedItem()"
    @getSelectedItems().forEach (preDiv)=>
      preDiv.zIndex = zIndex
    @record()

  becomeGroup_noUse:->
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

    @record()
  
  findInGroup_noUse:(preDiv)->
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

  exitGroup_noUse:->
    @getSelectedItems().forEach (preDiv)=>
      group = @findInGroup preDiv
      groupIndex = @groups.indexOf group
      @groups.splice groupIndex,1

    @record()

  getInRect:(gEData)-> #获取被框选元素
    checkType arguments,["object"],"DivList.getInRect()"
    @data.filter (preDiv)=>
      if ((  gEData.choiseBox2.x < preDiv.x < gEData.choiseBox2.x + gEData.choiseBox2.w ) and
      ( gEData.choiseBox2.y < preDiv.y < gEData.choiseBox2.y + gEData.choiseBox2.h)) or
      ((  gEData.choiseBox2.x < preDiv.x + preDiv.imgW < gEData.choiseBox2.x + gEData.choiseBox2.w ) and
      ( gEData.choiseBox2.y < preDiv.y < gEData.choiseBox2.y + gEData.choiseBox2.h)) or
      ((  gEData.choiseBox2.x < preDiv.x < gEData.choiseBox2.x + gEData.choiseBox2.w ) and
      ( gEData.choiseBox2.y < preDiv.y + preDiv.imgH < gEData.choiseBox2.y + gEData.choiseBox2.h)) or
      (( gEData.choiseBox2.x < preDiv.x + preDiv.imgW < gEData.choiseBox2.x + gEData.choiseBox2.w) and
      ( gEData.choiseBox2.y < preDiv.y + preDiv.imgH < gEData.choiseBox2.y + gEData.choiseBox2.h))
        return true
      else
        return false


  getInRect:(gEData)-> #获取被框选元素ai版本
    checkType arguments,["object"],"DivList.getInRect()"
    @data.filter (preDiv)=>
      x1 = Math.max(gEData.choiseBox2.x, preDiv.x)
      y1 = Math.max(gEData.choiseBox2.y, preDiv.y)
      x2 = Math.min(gEData.choiseBox2.x + gEData.choiseBox2.w, preDiv.x + preDiv.imgW)
      y2 = Math.min(gEData.choiseBox2.y + gEData.choiseBox2.h, preDiv.y + preDiv.imgH)
      return x1 < x2 && y1 < y2

  selectRectItems:->
  
    @getInRect(gEData).forEach (preDiv)=>
      if preDiv.lockState or preDiv.hideState
        return preDiv.cancelSelect()
    
      if @presentGroup
        if preDiv.linkid is @presentGroup
          preDiv.select 1
        else 
          preDiv.cancelSelect()
      else
        unless preDiv.linkid
          preDiv.select 1
        else 
          preDiv.cancelSelect()

    @getSelectedItems().forEach (preDiv)=>
      group = @findInGroup preDiv
      group?.forEach (preDiv1)=>
        preDiv1.select 2


  copySelectedItems:->
    idMap = {}
    
    @copy = @getSelectedItems().map (preDiv)=>
      div = new PreDiv {
        preDiv...
        x:preDiv.x + gEData.getW()
        y:preDiv.y + gEData.getH()
        id:uuid()
        hasBorder:1
        divList:@
      }
      return div

    @getSelectedItems().forEach (preDiv,index)=>
      idMap[preDiv.id] = @copy[index].id
      preDiv.hasBorder = 0

    @copy.forEach (preDiv)=>
      preDiv.linkid = idMap[preDiv.linkid] or ""

    return @copy

  pasteCopyedItems:->
    @data = [
      @data...
      @copy...
    ]

    @record()

  fillRect:->
    if (!gEData.choiseBox2.w or !gEData.choiseBox2.h or !gEData.choiseBox2.x or !gEData.choiseBox2.y)
      return Notice.launch
        msg:"请设置填充区域"
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
    @record()
          

  findChildren:(id)->
    checkType arguments,["string"],"gameEditor.DivList.findChildren()"
    groups = @data.filter (preDiv)=> preDiv.linkid is id

  findChildrenDeep:(id,index=0,childArr=[])->
    checkType arguments,["string","number?","array?"],"gameEditor.DivList.findChildrenDeep()"
    children = @findChildren(id)
    childArr.push(children...)
    children.forEach (child)=>
      @findChildrenDeep(child.id,index++,childArr)
    if childArr.length > 0
      return childArr
    else
      return null

  getGroups:->
    @data.filter (preDiv)=> preDiv.isGroup
  
  updateGroup:-> #根据子元素调整组边界
    @getGroups().forEach (group)=>
      children = @findChildrenDeep group.id
      x=y=x1=y1=z=0
      children.forEach (child,index)=>
        if index is 0
          x = child.x
          y = child.y
          x1 = child.x+child.imgW
          y1 = child.y+child.imgH
          z = child.zIndex
        x = if child.x < x then child.x else x
        y = if child.y < y then child.y else y
        x1 = if child.x+child.imgW > x1 then child.x+child.imgW else x1
        y1 = if child.y+child.imgH > y1 then child.y+child.imgH else y1
        z = if child.zIndex > z then child.zIndex else z

      group.x = x
      group.y = y
      group.imgW = x1-x
      group.imgH = y1-y
      group.zIndex = z+1
        


  becomeGroup:()->

    selectedItems = @getSelectedItems()
    
    selectedItems = selectedItems.filter (preDiv)=>
      if @presentGroup
        return preDiv.linkid is @presentGroup
      else 
        return not preDiv.linkid

    #beforeLinkid = selectedItems[0].linkid

    groupId = uuid()

    selectedItems.forEach (preDiv,index)=>
      preDiv.linkid = groupId

    group = new PreDiv {
      id:groupId
      linkid:@presentGroup or ""
      isGroup:true
      x:0
      y:0
      imgX:0
      imgY:0
      zIndex:99
      imgW:0
      imgH:0
      url:""
      hasBorder:1
    }
    group.changeId groupId

    @add group,true
    @updateGroup()
    @record()
  
  findInGroup:(preDiv)->
    unless preDiv instanceof PreDiv
      throw new Error "要查找所属组的元素不是PreDiv的实例"

    output = []

    fn = (preDiv)=>
      @data.forEach (item)=>
        if item.linkid is preDiv.id #and item.linkid isnt @presentGroup
          fn(item)
          output.push item
    fn(preDiv)
    
    if output.length > 0
      return output
    else
      return null

  setPresentGroup:(groupId)->
    checkType arguments,["string"],"gameEditor.DivList.setPresentGroup()"
    @presentGroup = groupId

  checkInPresentGroup:(preDiv)->
    if @presentGroup is ""
      unless preDiv.linkid
        return true
      else
        return false
    else
      if preDiv.linkid? is @presentGroup
        return true
      else
        return false

  cancelSelectAll:->
    @data.forEach (preDiv)=>
      preDiv.cancelSelect()

  isInGroup:(preDiv)->
    if @presentGroup
      if gEData.divList.findChildrenDeep(gEData.divList.presentGroup)?.find (child)=> child.id is preDiv.id
        return true
      else
        return false
    else
      return true

  exitGroup:->
    @getSelectedItems().forEach (preDiv)=>
      if preDiv.isGroup
        @data.forEach (dataPreDiv)=>
          if dataPreDiv.linkid is preDiv.id #修改子元素指向
            if preDiv.linkid
              dataPreDiv.linkid = preDiv.linkid
            else
              dataPreDiv.linkid = ""
        preDiv.del() #删除组

  hideOrShow:->
    @getSelectedItems().forEach (preDiv)=>
      preDiv.hideOrShow()
    @record()
  lockOrUnlock:->
    @getSelectedItems().forEach (preDiv)=>
      preDiv.lockOrUnlock()
    @record()
  hide:->
    @getSelectedItems().forEach (preDiv)=>
      preDiv.hide()
    @record()
  show:->
    @getSelectedItems().forEach (preDiv)=>
      preDiv.show()
    @record()
  lock:->
    @getSelectedItems().forEach (preDiv)=>
      preDiv.lock()
    @record()
  unlock:->
    @getSelectedItems().forEach (preDiv)=>
      preDiv.unlock()
    @record()
  
  hideOrShowCheckedItems:->
    @getCheckedItems().forEach (preDiv)=>
      preDiv.hideOrShow()
    @record()
  lockOrUnlockCheckedItems:->
    @getCheckedItems().forEach (preDiv)=>
      preDiv.lockOrUnlock()
    @record()
  

  save:->
    copyData = []
    @data.forEach (preDiv)=>
      cpPreDiv = {preDiv...}
      delete cpPreDiv.divList
      delete cpPreDiv.dom
      copyData.push cpPreDiv
    json = JSON.stringify copyData
    blob = new Blob [json]

    aDom = document.createElement "a"
    aDom.download = "data_#{Date.now()}.json"
    aDom.href = window.URL.createObjectURL blob
    document.body.appendChild aDom
    aDom.click()
    aDom.remove()
    
  
  import:()->
    json = null
    Notice.launch
      tip:"请选择“.json”格式的数据文件"
      content:->
        view:->
          m "",[
            m "input[type=file][accept=.json]",
              onchange:(e)=>
                try
                  file = e.target.files[0]
                  data = await new Promise (res,rej)=>
                    reader = new FileReader()
                    reader.onload = ()->
                      res(reader.result)
                    reader.readAsText(file)
                  json = JSON.parse data
                  unless json[0]?.id
                    throw new Error()
                catch err
                  console.log err
                  Notice.launch
                    msg:"导入失败，未知错误"

          ]
        
      confirm:=>
        @data = json.map (preDiv)=>
          new PreDiv {
            preDiv...
          }
        @record()
        return undefined

  export:->

    try
      canvas = document.createElement "canvas"
      canvas.width = gEData.canvasWidth
      canvas.height = gEData.canvasHeight
      ctx = canvas.getContext "2d"

      divListOrder = @data.sort (x1,x2)=> 
        Number(x1.dom.style.zIndex) - Number(x2.dom.style.zIndex) 

      for preDiv in divListOrder
        await do(preDiv)=>
          unless preDiv.hideState
            imgDom = await new Promise (res,rej)=>
              imgDom = new Image()
              imgDom.src = preDiv.url
              imgDom.onload = () =>
                res imgDom
              imgDom.onerror = (err)=>
                res imgDom
            

            ctx.drawImage imgDom,preDiv.imgX,preDiv.imgY,preDiv.imgW,preDiv.imgH,preDiv.x,preDiv.y,preDiv.imgW,preDiv.imgH
      
      #data = canvas.toDataURL "image/png"
      blob = await new Promise (res,rej)=>
        canvas.toBlob (blob)=>
          res(blob)
      
      aDom = document.createElement "a"
      aDom.download = "map_#{Date.now()}.png"
      aDom.href = window.URL.createObjectURL blob
      document.body.appendChild aDom
      aDom.click()
      aDom.remove()
    catch err
      console.log err




    

    



    

  
