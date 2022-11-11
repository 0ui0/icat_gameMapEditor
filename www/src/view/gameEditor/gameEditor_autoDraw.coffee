import gEData from "./gameEditor_data"
import PreDiv from "./gameEditor_preDiv"
import {v4 as uuid} from "uuid"

export default (x3,y3,x4,y4,notMove)->
  autoDivs = gEData.divList.data.filter (preDiv)=>
    return preDiv.autoType


  Part = class
    constructor:(site)->
      @x = gEData.getBoxX site.x
      @y = gEData.getBoxY site.y

    getPart:(num)->
    
      switch num
        when 1 then {@x,@y,type:"leftUpAngle"}
        when 2 then {x:@x+gEData.getW(),y:@y,type:"upEdge"}
        when 3 then {x:@x+gEData.getW()*2,y:@y,type:"rightUpAngle"}
        when 4 then {x:@x,y:@y+gEData.getH(),type:"leftEdge"}
        when 5 then {x:@x+gEData.getW(),y:@y+gEData.getH(),type:"crossBlock"}
        when 6 then {x:@x+gEData.getW()*2,y:@y+gEData.getH(),type:"rightEdge"}
        when 7 then {x:@x,y:@y+gEData.getH()*2,type:"leftDownAngle"}
        when 8 then {x:@x+gEData.getW(),y:@y+gEData.getH()*2,type:"downEdge"}
        when 9 then {x:@x+gEData.getW()*2,y:@y+gEData.getH()*2,type:"rightDownAngle"}

    getNeighbor:(num)->
      switch num

        when 1 then {x:@x,y:@y-gEData.getH()*3}
        when 2 then {x:@x+gEData.getW()*3,y:@y}
        when 3 then {x:@x,y:@y+gEData.getH()*3}
        when 4 then {x:@x-gEData.getW()*3,y:@y}

        when 5 then {x:@x-gEData.getW()*3,y:@y-gEData.getH()*3}
        when 6 then {x:@x+gEData.getW()*3,y:@y-gEData.getH()*3}
        when 7 then {x:@x-gEData.getW()*3,y:@y+gEData.getH()*3}
        when 8 then {x:@x+gEData.getW()*3,y:@y+gEData.getH()*3}

 

  fn = ->

    part = new Part {x:x4,y:y4}
    [1..9].forEach (num)=>
      partObj = part.getPart(num)
      gEData.divList.addNoRepeatAutoDraw new PreDiv
        id:uuid()
        x:partObj.x
        y:partObj.y
        imgX:gEData[partObj.type].x
        imgY:gEData[partObj.type].y
        imgW:gEData.getW()
        imgH:gEData.getH()
        url:gEData.tilesetUrl
        autoType:partObj.type
        autoMain:if num is 1 then true else false

    mainDivs = gEData.divList.data.filter (preDiv)=> preDiv.autoMain and not gEData.divList.findInGroup(preDiv)

    findDiv = ({x,y})=>
      gEData.divList.data.find (preDiv)=>
        preDiv.autoType and preDiv.x is x and preDiv.y is y and not gEData.divList.findInGroup(preDiv)

    findDivRotate = ({x,y})=>
      gEData.divList.data.find (preDiv)=>
        preDiv.autoType and preDiv.rotateX is x and preDiv.rotateY is y and not gEData.divList.findInGroup(preDiv)
    
    checkAndChange = (preDiv,part = null)->
      part = new Part preDiv
      dir = {}
      nine = {}

      dir_ = {}
      nine_ = {}

      [1..8].forEach (num)=>
        dir[num] = findDiv(part.getNeighbor(num))
      [1..9].forEach (num)=>
        nine[num] = findDiv(part.getPart(num))    

      
    
      dirToNineMap =
        1:2
        2:6
        3:8
        4:4
    
    
      [1..4].forEach (num)=>
        if dir[num] and nine[dirToNineMap[num]]
          nine[dirToNineMap[num]].imgX = gEData["crossBlock"].x
          nine[dirToNineMap[num]].imgY = gEData["crossBlock"].y

      #准备旋转
      ###

        rotate = (alpha,{x,y},{x:x0,y:y0}={x:0,y:0})->
          x = x-x0
          y = y-y0
          return 
            x: Math.cos(alpha)*x - Math.sin(alpha)*y + x0
            y: Math.sin(alpha)*x + Math.cos(alpha)*y + y0

        [0,-Math.PI/2,-Math.PI,-(Math.PI/2)*3].forEach (alpha,index)=>

          gEData.divList.data.forEach (preDiv)=>
            site = rotate(alpha,preDiv,{
              x:nine[5].x
              y:nine[5].y
            })
            preDiv.rotateX = site.x
            preDiv.rotateY = site.y 

          [1..8].forEach (num)=>
            dir_[num] = findDivRotate(part.getNeighbor(num))
          [1..9].forEach (num)=>
            nine_[num] = findDivRotate(part.getPart(num))   


          rightUpAngle2 = switch index+1
            when 1 then "rightUpAngle2"
            when 2 then "rightDownAngle2"
            when 3 then "leftDownAngle2"
            when 4 then "leftUpAngle2" 
          
          
          rightEdge = switch index+1
            when 1 then "rightEdge"
            when 2 then "downEdge"
            when 3 then "leftEdge"
            when 4 then "upEdge"

          upEdge = switch index+1
            when 1 then "upEdge"
            when 2 then "rightEdge"
            when 3 then "downEdge"
            when 4 then "leftEdge"


          if dir_[1] and dir_[2] and dir_[6]
            nine_[3].imgX = gEData["crossBlock"].x
            nine_[3].imgY = gEData["crossBlock"].y
            console.log 3
          

          else if dir_[1] and dir_[2]
            nine_[3].imgX = gEData[rightUpAngle2].x
            nine_[3].imgY = gEData[rightUpAngle2].y
            console.log 2


          else if dir_[1]
            nine_[3].imgX = gEData[rightEdge].x
            nine_[3].imgY = gEData[rightEdge].y
            console.log 1.1

          else if dir_[2]
            nine_[3].imgX = gEData[upEdge].x
            nine_[3].imgY = gEData[upEdge].y
            console.log 1.2
      ###
      if nine[3]
        if dir[1] and dir[2] and dir[6]
          nine[3].imgX = gEData["crossBlock"].x
          nine[3].imgY = gEData["crossBlock"].y 
        else if dir[1] and dir[2]
          nine[3].imgX = gEData["rightUpAngle2"].x
          nine[3].imgY = gEData["rightUpAngle2"].y 
        else if dir[1]
          nine[3].imgX = gEData["rightEdge"].x
          nine[3].imgY = gEData["rightEdge"].y 
        else if dir[2]
          nine[3].imgX = gEData["upEdge"].x
          nine[3].imgY = gEData["upEdge"].y 

      if nine[9]

        if dir[2] and dir[3] and dir[8]
          nine[9].imgX = gEData["crossBlock"].x
          nine[9].imgY = gEData["crossBlock"].y 
        else if dir[2] and dir[3]
          nine[9].imgX = gEData["rightDownAngle2"].x
          nine[9].imgY = gEData["rightDownAngle2"].y 
        else if dir[2]
          nine[9].imgX = gEData["downEdge"].x
          nine[9].imgY = gEData["downEdge"].y 
        else if dir[3]
          nine[9].imgX = gEData["rightEdge"].x
          nine[9].imgY = gEData["rightEdge"].y 

      if nine[7]

        if dir[3] and dir[4] and dir[7]
          nine[7].imgX = gEData["crossBlock"].x
          nine[7].imgY = gEData["crossBlock"].y 
        else if dir[3] and dir[4]
          nine[7].imgX = gEData["leftDownAngle2"].x
          nine[7].imgY = gEData["leftDownAngle2"].y 
        else if dir[3]
          nine[7].imgX = gEData["leftEdge"].x
          nine[7].imgY = gEData["leftEdge"].y 
        else if dir[4]
          nine[7].imgX = gEData["downEdge"].x
          nine[7].imgY = gEData["downEdge"].y 

      if nine[1]
        if dir[4] and dir[1] and dir[5]
          nine[1].imgX = gEData["crossBlock"].x
          nine[1].imgY = gEData["crossBlock"].y 
        else if dir[4] and dir[1]
          nine[1].imgX = gEData["leftUpAngle2"].x
          nine[1].imgY = gEData["leftUpAngle2"].y 
        else if dir[4]
          nine[1].imgX = gEData["upEdge"].x
          nine[1].imgY = gEData["upEdge"].y 
        else if dir[1]
          nine[1].imgX = gEData["leftEdge"].x
          nine[1].imgY = gEData["leftEdge"].y 



    mainDivs.forEach (preDiv)=>
      checkAndChange(preDiv)

  unless notMove
    if ((gEData.getBoxX(x4)-gEData.getBoxX(x3)) %(gEData.getW()*3) is 0 and
    (gEData.getBoxY(y4)-gEData.getBoxX(y3))%(gEData.getH()*3) is 0)
      fn()
  else
    fn()
    