// Generated by CoffeeScript 2.6.1
import gEData from "./gameEditor_data";

import Box from "../common/box";

import getColor from "../help/getColor";

import {
  v4 as uuid
} from "uuid";

import PreDiv from "./gameEditor_preDiv";

import autoDraw from "./gameEditor_autoDraw";

export default function() {
  var fnDown1, fnDown1_move, fnDown1_up, fnDown2, fnDown2_move, fnDown2_up, fnDown3, fnDown3_up, fnMove, fnOut;
  fnOut = fnDown1 = fnDown2 = fnDown3 = fnMove = fnDown1_move = fnDown1_up = fnDown2_move = fnDown2_up = fnDown3_up = null;
  return {
    view: function() {
      return m("#paper", {
        oncreate: ({dom}) => {
          var dir, fnOver, img;
          dir = "";
          img = null;
          if (!fnOut) {
            dom.addEventListener("mouseout", fnOut = function(e) {
              gEData.pen.show = false;
              return m.redraw();
            });
          }
          /*

          fnDown1 = dom.removeEventListener "mousedown",fnDown1
          fnDown2 = dom.removeEventListener "mousedown",fnDown2
          fnMove = dom.removeEventListener "mousemove",fnMove
          fnDown1_move = dom.removeEventListener "mousemove",fnDown1_move
          fnDown2_move = dom.removeEventListener "mousemove",fnDown2_move
          fnDown1_up = dom.removeEventListener "mouseup",fnDown1_up
          fnDown2_up = dom.removeEventListener "mouseup",fnDown2_up
          */
          //fnOut = dom.removeEventListener "mouseout",fnOut
          if (!fnOver) {
            return dom.addEventListener("mouseover", fnOver = function(e1) {
              var x1, y1;
              x1 = e1.offsetX;
              y1 = e1.offsetY;
              if (gEData.mouseState === "pen") {
                gEData.pen.show = true;
              } else {
                gEData.pen.show = false;
              }
              m.redraw();
              if (!fnMove) {
                dom.addEventListener("mousemove", fnMove = function(e2) {
                  var x2, y2;
                  if (gEData.mouseState !== "pen") {
                    return;
                  }
                  x2 = e2.offsetX;
                  y2 = e2.offsetY;
                  gEData.pen.x = gEData.getBoxX(x2);
                  gEData.pen.y = gEData.getBoxY(y2);
                  return m.redraw();
                });
              }
              //?????????
              if (!fnDown1) {
                dom.addEventListener("mousedown", fnDown1 = function(e3) {
                  var preDiv, x3, y3;
                  if (e3.button !== 0) {
                    return;
                  }
                  //console.log "down"
                  if (gEData.mouseState !== "pen") {
                    return;
                  }
                  x3 = e3.offsetX;
                  y3 = e3.offsetY;
                  if (gEData.autoDraw) {
                    autoDraw(x1, y1, x3, y3, true);
                    //=======
                    m.redraw();
                  } else {
                    preDiv = new PreDiv({
                      id: uuid(),
                      x: gEData.getBoxX(x3),
                      y: gEData.getBoxY(y3),
                      imgX: gEData.choiseBox.x,
                      imgY: gEData.choiseBox.y,
                      imgW: gEData.choiseBox.w,
                      imgH: gEData.choiseBox.h,
                      url: gEData.tilesetUrl
                    });
                    gEData.divList.addNoRepeat(preDiv);
                  }
                  if (!fnDown1_move) {
                    dom.addEventListener("mousemove", fnDown1_move = function(e4) {
                      var x4, y4;
                      if (gEData.mouseState !== "pen") {
                        return;
                      }
                      x4 = e4.offsetX;
                      y4 = e4.offsetY;
                      if (gEData.autoDraw) {
                        return autoDraw(x3, y3, x4, y4);
                      } else {
                        if ((gEData.getBoxX(x4) - gEData.getBoxX(x3)) % gEData.choiseBox.w === 0 && (gEData.getBoxY(y4) - gEData.getBoxX(y3)) % gEData.choiseBox.h === 0) {
                          preDiv = new PreDiv({
                            id: uuid(),
                            x: gEData.getBoxX(x4),
                            y: gEData.getBoxY(y4),
                            imgX: gEData.choiseBox.x,
                            imgY: gEData.choiseBox.y,
                            imgW: gEData.choiseBox.w,
                            imgH: gEData.choiseBox.h,
                            url: gEData.tilesetUrl
                          });
                          return gEData.divList.addNoRepeat(preDiv);
                        }
                      }
                    });
                  }
                  /*
                  img = new Image(gEData.choiseBox.w,gEData.choiseBox.h)#
                  img.src = gEData.texture

                  img.onload = ->

                    ctx = dom.getContext "2d"
                    if dir is "x"
                      ctx.drawImage img,gEData.getBoxX(x4),gEData.getBoxY(y3)
                    if dir is "y"
                      ctx.drawImage img,gEData.getBoxX(x3),gEData.getBoxY(y4)
                  */
                  if (!fnDown1_up) {
                    return dom.addEventListener("mouseup", fnDown1_up = function() {
                      if (gEData.mouseState !== "pen") {
                        fnDown1_move = dom.removeEventListener("mousemove", fnDown1_move);
                        fnDown1_up = dom.removeEventListener("mouseup", fnDown1_up);
                        return;
                      }
                      dir = "";
                      fnDown1_move = dom.removeEventListener("mousemove", fnDown1_move);
                      return fnDown1_up = dom.removeEventListener("mouseup", fnDown1_up);
                    });
                  }
                });
              }
              
              //?????????
              if (!fnDown2) {
                dom.addEventListener("mousedown", fnDown2 = function(e3) {
                  var domX, domY;
                  if (e3.button !== 0) {
                    return;
                  }
                  if (gEData.mouseState !== "mouse") {
                    return;
                  }
                  if (gEData.downkeys[0] !== 16) { //shift???
                    gEData.divList.data.forEach((preDiv) => {
                      return preDiv.cancelSelect();
                    });
                  }
                  x1 = e3.clientX;
                  y1 = e3.clientY;
                  domX = dom.getBoundingClientRect().x;
                  domY = dom.getBoundingClientRect().y;
                  gEData.choiseBox2.x = gEData.choiseBox2.x + gEData.choiseBox2.w;
                  gEData.choiseBox2.y = gEData.choiseBox2.y + gEData.choiseBox2.h;
                  gEData.choiseBox2.w = 0;
                  gEData.choiseBox2.h = 0;
                  m.redraw();
                  if (!fnDown2_move) {
                    document.addEventListener("mousemove", fnDown2_move = function(e4) {
                      var disX, disY, x2, y2;
                      //console.log "move"
                      if (gEData.mouseState !== "mouse") {
                        return;
                      }
                      x2 = e4.clientX;
                      y2 = e4.clientY;
                      disX = x2 - x1;
                      disY = y2 - y1;
                      if (disX > 0) {
                        gEData.choiseBox2.x = x1 - domX;
                        gEData.choiseBox2.w = Math.abs(disX);
                      } else {
                        gEData.choiseBox2.x = x2 - domX;
                        gEData.choiseBox2.w = Math.abs(disX);
                      }
                      if (disY > 0) {
                        gEData.choiseBox2.y = y1 - domY;
                        gEData.choiseBox2.h = Math.abs(disY);
                      } else {
                        gEData.choiseBox2.y = y2 - domY;
                        gEData.choiseBox2.h = Math.abs(disY);
                      }
                      return m.redraw();
                    });
                  }
                  if (!fnDown2_up) {
                    return document.addEventListener("mouseup", fnDown2_up = function(e5) {
                      if (gEData.mouseState !== "mouse") {
                        fnDown2_move = document.removeEventListener("mousemove", fnDown2_move);
                        fnDown2_up = document.removeEventListener("mouseup", fnDown2_up);
                        return;
                      }
                      gEData.divList.selectRectItems();
                      m.redraw();
                      fnDown2_move = document.removeEventListener("mousemove", fnDown2_move);
                      return fnDown2_up = document.removeEventListener("mouseup", fnDown2_up);
                    });
                  }
                });
              }
              //??????
              if (!fnDown3) {
                return dom.addEventListener("contextmenu", fnDown3 = function(e) {
                  if (gEData.mouseState !== "mouse") {
                    return;
                  }
                  if (gEData.divList.getSelectedItems().length <= 0) {
                    return;
                  }
                  gEData.RightMenu.data.show = true;
                  gEData.rightMenuTop = e.clientY;
                  gEData.rightMenuLeft = e.clientX;
                  gEData.RightMenu.data.items = [
                    {
                      name: "????????????",
                      click: function() {
                        return gEData.divList.changeZIndexSelectedItems(5);
                      }
                    },
                    {
                      name: "????????????",
                      click: function() {
                        return gEData.divList.changeZIndexSelectedItems(-5);
                      }
                    },
                    {
                      name: "??????",
                      click: function() {
                        gEData.divList.becomeGroup();
                        return gEData.RightMenu.data.show = false;
                      }
                    },
                    {
                      name: "??????",
                      click: function() {
                        gEData.divList.exitGroup();
                        return gEData.RightMenu.data.show = false;
                      }
                    },
                    {
                      name: "??????",
                      click: function() {
                        gEData.divList.delSelectedItems();
                        gEData.RightMenu.data.show = false;
                        return m.redraw();
                      }
                    }
                  ];
                  e.preventDefault();
                  return m.redraw();
                }, {
                  passive: false
                });
              }
            });
          }
        },
        style: {
          width: `${gEData.canvasWidth}px`,
          height: `${gEData.canvasHeight}px`,
          position: "relative",
          background: "#fff",
          overflow: "hidden",
          border: "0.1rem solid #aaa"
        }
      }, [
        gEData.divList.data.map((preDiv,
        index) => {
          return m("",
        {
            key: preDiv.id,
            "data-id": preDiv.id,
            "data-linkid": preDiv.linkid,
            oncreate: ({dom}) => {
              preDiv.dom = dom;
              //????????????
              dom.addEventListener("contextmenu",
        function(e) {
                gEData.RightMenu.data.show = true;
                gEData.rightMenuTop = e.clientY;
                gEData.rightMenuLeft = e.clientX;
                gEData.RightMenu.data.items = [
                  {
                    name: "????????????",
                    click: function() {
                      return gEData.divList.changeZIndexSelectedItems(5);
                    }
                  },
                  {
                    name: "????????????",
                    click: function() {
                      return gEData.divList.changeZIndexSelectedItems(-5);
                    }
                  },
                  {
                    name: "??????",
                    click: function() {
                      gEData.divList.becomeGroup();
                      return gEData.RightMenu.data.show = false;
                    }
                  },
                  {
                    name: "??????",
                    click: function() {
                      gEData.divList.exitGroup();
                      return gEData.RightMenu.data.show = false;
                    }
                  },
                  {
                    name: "??????",
                    click: function() {
                      gEData.divList.delSelectedItems();
                      gEData.RightMenu.data.show = false;
                      return m.redraw();
                    }
                  }
                ];
                return e.preventDefault();
              },
        {
                passive: false
              });
              dom.addEventListener("click",
        function(e) {
                return e.stopPropagation();
              },
        {
                passive: false
              });
              dom.addEventListener("dblclick",
        function(e) {
                if (preDiv.isGroup) {
                  gEData.divList.setPresentGroup(preDiv.id);
                  gEData.divList.cancelSelectAll();
                }
                return e.stopPropagation();
              },
        {
                passive: false
              });
              return dom.addEventListener("mousedown",
        function(e1) {
                var fnUp,
        ref,
        x1,
        y1;
                e1.stopPropagation();
                x1 = e1.clientX;
                y1 = e1.clientY;
                gEData.RightMenu.data.show = false;
                //??????shift?????????????????????
                if (gEData.downkeys[0] !== 16) { //shift???
                  //???????????????????????????????????????????????????????????????
                  if (!gEData.divList.getSelectedItems().find((preDiv1) => {
                    return preDiv1 === preDiv;
                  })) {
                    gEData.divList.data.forEach((preDiv1) => {
                      return preDiv1.cancelSelect();
                    });
                  }
                }
                preDiv.select(1);
                //??????????????????
                if ((ref = gEData.divList.findInGroup(preDiv)) != null) {
                  ref.forEach((preDiv) => {
                    return preDiv.select(2); //????????????
                  });
                }
                
                //????????????
                gEData.choiseBox2.w = 0;
                gEData.choiseBox2.h = 0;
                m.redraw();
                //??????document???????????????????????????????????????????????????????????????
                /*
                document.addEventListener "click",fnClick = ()=>
                  gEData.divList.data.forEach (preDiv1)=>
                    preDiv1.cancelSelect()
                  m.redraw()
                  document.removeEventListener "click",fnClick
                */
                document.addEventListener("mousemove",
        fnMove = function(e2) {
                  var disX,
        disY,
        x2,
        y2;
                  e2.stopPropagation();
                  if (!preDiv.hasBorder) {
                    return;
                  }
                  x2 = e2.clientX;
                  y2 = e2.clientY;
                  disX = x2 - x1;
                  disY = y2 - y1;
                  //?????????????????????
                  gEData.divList.translateSelectedItems(disX,
        disY);
                  m.redraw();
                  x1 = x2;
                  return y1 = y2;
                },
        {
                  passive: false
                });
                return document.addEventListener("mouseup",
        fnUp = function(e3) {
                  e3.stopPropagation();
                  if (!preDiv.hasBorder) {
                    return;
                  }
                  //????????????????????????????????????
                  gEData.divList.getSelectedItems().forEach((preDiv) => {
                    preDiv.x = gEData.getBoxX(preDiv.x);
                    return preDiv.y = gEData.getBoxY(preDiv.y);
                  });
                  m.redraw();
                  gEData.divList.record(); //????????????
                  document.removeEventListener("mousemove",
        fnMove);
                  return document.removeEventListener("mouseup",
        fnUp);
                },
        {
                  passive: false
                });
              },
        {
                passive: false
              });
            },
            style: {
              zIndex: preDiv.zIndex,
              position: "absolute",
              left: 0,
              top: 0,
              display: "inline-block",
              opacity: gEData.divList.isInGroup(preDiv) ? 1 : 0.5,
              //translate:"#{preDiv.x}px #{preDiv.y}px"
              transform: `translate(${preDiv.x}px,${preDiv.y}px)`,
              width: `${preDiv.imgW}px`,
              height: `${preDiv.imgH}px`,
              backgroundImage: `url(${preDiv.url})`,
              backgroundPosition: `-${preDiv.imgX}px -${preDiv.imgY}px`,
              backgroundRepeat: "no-repeat",
              boxSizing: "border-box",
              pointerEvents: gEData.mouseState === "pen" ? "none" : gEData.divList.isInGroup(preDiv) ? "auto" : "none",
              border: preDiv.hasBorder === 1 ? `0.2rem solid ${getColor("yellow").back}` : preDiv.hasBorder === 2 ? `0.2rem solid ${getColor("green").back}` : void 0
            }
          },
        [
            gEData.divList.showZIndex ? m("",
            {
              style: {
                color: "white",
                fontSize: "1.3rem",
                wordBreak: "break-all",
                wordWrap: "overflow-wrap"
              }
            },
            "?????????" + preDiv.zIndex) : void 0
          ]);
        })
      ]);
    }
  };
};
