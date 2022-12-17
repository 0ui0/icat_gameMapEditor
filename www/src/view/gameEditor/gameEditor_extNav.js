// Generated by CoffeeScript 2.6.1
var autoDrawExamples;

import gEData from "./gameEditor_data";

import Box from "../common/box";

import Tag from "../common/tag";

import Notice from "../common/notice";

import getColor from "../help/getColor";

autoDrawExamples = [["leftUpAngle", "upEdge", "rightUpAngle", "leftEdge", "crossBlock", "rightEdge", "leftDownAngle", "downEdge", "rightDownAngle"], ["leftUpAngle2", "crossBlock", "rightUpAngle2", "crossBlock", "crossBlock", "crossBlock", "leftDownAngle2", "crossBlock", "rightDownAngle2"]];

export default function() {
  return {
    view: function() {
      return m("", {
        style: {
          position: "fixed",
          bottom: "2rem",
          left: "50%",
          transform: "translate(-50%, 0px)",
          //background:getColor("yellow").back
          background: "rgba(215,215,215,0.7)",
          borderRadius: "3rem",
          minWidth: "50rem",
          display: "flex",
          justifyContent: "center",
          alignItems: "center"
        }
      }, [
        gEData.autoDraw ? m("",
        {
          style: {
            display: "inline-flex",
            justifyContent: "center",
            alignItems: "center",
            borderRadius: "3rem"
          }
        },
        [
          /*
          m "table",[
            gEData.autoDrawNames.map ({en,cn})=>
              m "tr",[
                m "td",[
                  m Box,
                    isBtn:yes
                    color:if gEData[en] then "deepBlue" else "green"
                    onclick: =>
                      gEData[en]=
                        x:gEData.choiseBox.x
                        y:gEData.choiseBox.y
                  ,cn + "#{if gEData[en] then "(#{gEData[en].x},#{gEData[en].y})" else ""}"
                ]
                m "td",[
                  m "img",
                    src:"./statics/cut/#{en}.png"

                ]
              ]

          ]
          */
          //background:getColor("brown").back
          gEData.autoDrawSeletor ? m("",
          {
            style: {
              display: "grid",
              gridTemplateColumns: "1fr 1fr",
              gridGap: "1rem",
              margin: "1rem"
            }
          },
          [
            autoDrawExamples.map((exN,
            index) => {
              return m("",
            {
                style: {
                  display: "grid",
                  gridTemplateRows: "repeat(3,48px)",
                  gridTemplateColumns: "repeat(3,48px)"
                }
              },
            [
                exN.map((mapUnit) => {
                  return m("",
                {
                    style: {
                      display: "inline-flex",
                      backgroundImage: gEData[mapUnit] ? `url(${gEData.tilesetUrl})` : `url(./statics/cut/${mapUnit}.png)`,
                      backgroundPosition: gEData[mapUnit] ? `-${gEData[mapUnit].x}px -${gEData[mapUnit].y}px` : void 0,
                      cursor: "pointer",
                      width: "48px",
                      height: "48px",
                      boxSizing: "border-box",
                      transition: "transform 1s ease",
                      transform: "scale(1)",
                      boxShadow: "",
                      outline: gEData[mapUnit] ? `0.1rem solid ${getColor("green").back}` : void 0,
                      borderTop: mapUnit.match(/up/gi) ? `0.5rem dashed ${getColor("red").back}` : void 0,
                      borderBottom: mapUnit.match(/down/gi) ? `0.5rem dashed ${getColor("red").back}` : void 0,
                      borderLeft: mapUnit.match(/left/gi) ? `0.5rem dashed ${getColor("red").back}` : void 0,
                      borderRight: mapUnit.match(/right/gi) ? `0.5rem dashed ${getColor("red").back}` : void 0
                    },
                    onmouseover: (e) => {
                      e.target.style.transform = "scale(1.2)";
                      return e.target.style.boxShadow = "0 0 1rem rgba(0,0,0,0.3)";
                    },
                    onmouseout: (e) => {
                      e.target.style.transform = "scale(1)";
                      return e.target.style.boxShadow = "";
                    },
                    onclick: () => {
                      return gEData[mapUnit] = {
                        x: gEData.choiseBox.x,
                        y: gEData.choiseBox.y
                      };
                    }
                  },
                []);
                })
              ]);
            })
          ]) : void 0,
          /*
          m "",
            style:
              color:"#eee"
              PointerEvents: "none"
          ,gEData.autoDrawNames.find((item)=>item.en is mapUnit).cn
          */
          m("",
          [
            m(Box,
            {
              isBtn: true,
              onclick: () => {
                return gEData.autoDrawSeletor = !gEData.autoDrawSeletor;
              }
            },
            gEData.autoDrawSeletor ? "收起" : "展开选择"),
            m(Box,
            {
              isBtn: true,
              onclick: () => {
                return gEData.clearAutoDrawConfig();
              }
            },
            "清除已选")
          ])
        ]) : void 0,
        gEData.divList.presentGroup ? [
          gEData.autoDraw ? m("span",
          {
            style: {
              display: "inline-block",
              width: "0.2rem",
              background: "#aaa",
              height: "3rem",
              borderRadius: "0.5rem"
            }
          }) : void 0,
          m(Box,
          gEData.divList.presentGroup.slice(0, 6) + "..."),
          m(Box,
          {
            isBtn: true,
            onclick: () => {
              gEData.divList.setPresentGroup("");
              return gEData.divList.cancelSelectAll();
            }
          },
          "退出组")
        ] : void 0,
        gEData.divList.groupLevel > 0 ? [
          m(Box,
          `场景${gEData.divList.groupLevel}`),
          m(Box,
          {
            isBtn: true,
            onclick: () => {
              if (gEData.divList.groupLevel - 1 >= 0) {
                return gEData.divList.groupLevel--;
              }
            }
          },
          "上级场景"),
          m(Box,
          {
            isBtn: true,
            onclick: () => {
              return gEData.divList.groupLevel = 0;
            }
          },
          "主场景")
        ] : void 0
      ]);
    }
  };
};
