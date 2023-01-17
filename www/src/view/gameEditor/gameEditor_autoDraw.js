// Generated by CoffeeScript 2.6.1
import gEData from "./gameEditor_data";

import PreDiv from "./gameEditor_preDiv";

import {
  v4 as uuid
} from "uuid";

export default function(x3, y3, x4, y4, notMove) {
  var Part, autoDivs, fn;
  autoDivs = gEData.divList.data.filter((preDiv) => {
    return preDiv.autoType;
  });
  Part = class {
    constructor(site) {
      this.x = gEData.getBoxX(site.x);
      this.y = gEData.getBoxY(site.y);
    }

    getPart(num) {
      switch (num) {
        case 1:
          return {
            x: this.x,
            y: this.y,
            type: "leftUpAngle"
          };
        case 2:
          return {
            x: this.x + gEData.getW(),
            y: this.y,
            type: "upEdge"
          };
        case 3:
          return {
            x: this.x + gEData.getW() * 2,
            y: this.y,
            type: "rightUpAngle"
          };
        case 4:
          return {
            x: this.x,
            y: this.y + gEData.getH(),
            type: "leftEdge"
          };
        case 5:
          return {
            x: this.x + gEData.getW(),
            y: this.y + gEData.getH(),
            type: "crossBlock"
          };
        case 6:
          return {
            x: this.x + gEData.getW() * 2,
            y: this.y + gEData.getH(),
            type: "rightEdge"
          };
        case 7:
          return {
            x: this.x,
            y: this.y + gEData.getH() * 2,
            type: "leftDownAngle"
          };
        case 8:
          return {
            x: this.x + gEData.getW(),
            y: this.y + gEData.getH() * 2,
            type: "downEdge"
          };
        case 9:
          return {
            x: this.x + gEData.getW() * 2,
            y: this.y + gEData.getH() * 2,
            type: "rightDownAngle"
          };
      }
    }

    getNeighbor(num) {
      switch (num) {
        case 1:
          return {
            x: this.x,
            y: this.y - gEData.getH() * 3
          };
        case 2:
          return {
            x: this.x + gEData.getW() * 3,
            y: this.y
          };
        case 3:
          return {
            x: this.x,
            y: this.y + gEData.getH() * 3
          };
        case 4:
          return {
            x: this.x - gEData.getW() * 3,
            y: this.y
          };
        case 5:
          return {
            x: this.x - gEData.getW() * 3,
            y: this.y - gEData.getH() * 3
          };
        case 6:
          return {
            x: this.x + gEData.getW() * 3,
            y: this.y - gEData.getH() * 3
          };
        case 7:
          return {
            x: this.x - gEData.getW() * 3,
            y: this.y + gEData.getH() * 3
          };
        case 8:
          return {
            x: this.x + gEData.getW() * 3,
            y: this.y + gEData.getH() * 3
          };
      }
    }

  };
  fn = function() {
    var checkAndChange, findDiv, findDivRotate, mainDivs, part;
    part = new Part({
      x: x4,
      y: y4
    });
    [1, 2, 3, 4, 5, 6, 7, 8, 9].forEach((num) => {
      var partObj;
      partObj = part.getPart(num);
      return gEData.divList.addNoRepeatAutoDraw(new PreDiv({
        id: uuid(),
        x: partObj.x,
        y: partObj.y,
        imgX: gEData[partObj.type].x,
        imgY: gEData[partObj.type].y,
        imgW: gEData.getW(),
        imgH: gEData.getH(),
        url: gEData.tilesetUrl,
        autoType: partObj.type,
        autoMain: num === 1 ? true : false
      }));
    });
    mainDivs = gEData.divList.data.filter((preDiv) => {
      return preDiv.autoMain && (!preDiv.linkid || preDiv.linkid === gEData.divList.presentGroup);
    });
    findDiv = ({x, y}) => {
      return gEData.divList.data.find((preDiv) => {
        return preDiv.autoType && preDiv.x === x && preDiv.y === y && (!preDiv.linkid || preDiv.linkid === gEData.divList.presentGroup);
      });
    };
    findDivRotate = ({x, y}) => {
      return gEData.divList.data.find((preDiv) => {
        return preDiv.autoType && preDiv.rotateX === x && preDiv.rotateY === y && (!preDiv.linkid || preDiv.linkid === gEData.divList.presentGroup);
      });
    };
    checkAndChange = function(preDiv, part = null) {
      var dir, dirToNineMap, dir_, nine, nine_;
      part = new Part(preDiv);
      dir = {};
      nine = {};
      dir_ = {};
      nine_ = {};
      [1, 2, 3, 4, 5, 6, 7, 8].forEach((num) => {
        return dir[num] = findDiv(part.getNeighbor(num));
      });
      [1, 2, 3, 4, 5, 6, 7, 8, 9].forEach((num) => {
        return nine[num] = findDiv(part.getPart(num));
      });
      dirToNineMap = {
        1: 2,
        2: 6,
        3: 8,
        4: 4
      };
      [1, 2, 3, 4].forEach((num) => {
        if (dir[num] && nine[dirToNineMap[num]]) {
          nine[dirToNineMap[num]].imgX = gEData["crossBlock"].x;
          return nine[dirToNineMap[num]].imgY = gEData["crossBlock"].y;
        }
      });
      //准备旋转
      /*

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
      */
      if (nine[3]) {
        if (dir[1] && dir[2] && dir[6]) {
          nine[3].imgX = gEData["crossBlock"].x;
          nine[3].imgY = gEData["crossBlock"].y;
        } else if (dir[1] && dir[2]) {
          nine[3].imgX = gEData["rightUpAngle2"].x;
          nine[3].imgY = gEData["rightUpAngle2"].y;
        } else if (dir[1]) {
          nine[3].imgX = gEData["rightEdge"].x;
          nine[3].imgY = gEData["rightEdge"].y;
        } else if (dir[2]) {
          nine[3].imgX = gEData["upEdge"].x;
          nine[3].imgY = gEData["upEdge"].y;
        }
      }
      if (nine[9]) {
        if (dir[2] && dir[3] && dir[8]) {
          nine[9].imgX = gEData["crossBlock"].x;
          nine[9].imgY = gEData["crossBlock"].y;
        } else if (dir[2] && dir[3]) {
          nine[9].imgX = gEData["rightDownAngle2"].x;
          nine[9].imgY = gEData["rightDownAngle2"].y;
        } else if (dir[2]) {
          nine[9].imgX = gEData["downEdge"].x;
          nine[9].imgY = gEData["downEdge"].y;
        } else if (dir[3]) {
          nine[9].imgX = gEData["rightEdge"].x;
          nine[9].imgY = gEData["rightEdge"].y;
        }
      }
      if (nine[7]) {
        if (dir[3] && dir[4] && dir[7]) {
          nine[7].imgX = gEData["crossBlock"].x;
          nine[7].imgY = gEData["crossBlock"].y;
        } else if (dir[3] && dir[4]) {
          nine[7].imgX = gEData["leftDownAngle2"].x;
          nine[7].imgY = gEData["leftDownAngle2"].y;
        } else if (dir[3]) {
          nine[7].imgX = gEData["leftEdge"].x;
          nine[7].imgY = gEData["leftEdge"].y;
        } else if (dir[4]) {
          nine[7].imgX = gEData["downEdge"].x;
          nine[7].imgY = gEData["downEdge"].y;
        }
      }
      if (nine[1]) {
        if (dir[4] && dir[1] && dir[5]) {
          nine[1].imgX = gEData["crossBlock"].x;
          return nine[1].imgY = gEData["crossBlock"].y;
        } else if (dir[4] && dir[1]) {
          nine[1].imgX = gEData["leftUpAngle2"].x;
          return nine[1].imgY = gEData["leftUpAngle2"].y;
        } else if (dir[4]) {
          nine[1].imgX = gEData["upEdge"].x;
          return nine[1].imgY = gEData["upEdge"].y;
        } else if (dir[1]) {
          nine[1].imgX = gEData["leftEdge"].x;
          return nine[1].imgY = gEData["leftEdge"].y;
        }
      }
    };
    return mainDivs.forEach((preDiv) => {
      return checkAndChange(preDiv);
    });
  };
  if (!notMove) {
    if ((gEData.getBoxX(x4) - gEData.getBoxX(x3)) % (gEData.getW() * 3) === 0 && (gEData.getBoxY(y4) - gEData.getBoxX(y3)) % (gEData.getH() * 3) === 0) {
      return fn();
    }
  } else {
    return fn();
  }
};
