// Generated by CoffeeScript 2.6.1
import Box from "./box";

import getColor from "../help/getColor";

import Comp from "./noticeComp";

export default {
  data: {
    compArr: [],
    show: false
  },
  launch: function(obj) {
    var comp;
    checkType(arguments, ["object"], "Notice.launch(obj)");
    comp = Comp(obj);
    // 如果组件已经有了，就不再添加
    if (!this.data.compArr.find((item) => {
      return item.sign === obj.sign;
    })) {
      this.data.compArr = [comp, ...this.data.compArr];
    }
    this.data.show = true;
    return m.redraw();
  },
  view: function() {
    var _this;
    _this = this;
    if (this.data.show) {
      return m("", {
        style: {
          zIndex: 9999999999999,
          position: "fixed",
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          maxHeight: "100vh",
          background: "rgba(0,0,0,0.5)",
          alignItems: "center",
          boxShadow: "0.1rem 0.1rem 1rem rgba(0,0,0,0.5)"
        }
      }, [
        m("",
        {
          style: {
            width: "100%",
            height: "100%",
            display: this.data.compArr.length <= 2 ? "flex" : void 0,
            flexDirection: Mob ? "row" : "column",
            flexWrap: "wrap",
            justifyContent: "center",
            alignItems: "center",
            overflow: "auto"
          }
        },
        [
          this.data.compArr.map((item,
          index) => {
            return m(item,
          {
              compArr: this.data.compArr,
              key: item.sign || index,
              closeLayer: () => {
                if (this.data.compArr.length === 0) {
                  return this.data.show = false;
                }
              },
              delete: () => {
                //添加元素后会导致index变化，可能会删除错误
                //所以需要重新查找正确的index
                index = this.data.compArr.indexOf(item);
                /*
                console.log index
                console.log @data.compArr
                setTimeout =>
                  console.log @data.compArr
                ,500
                */
                if (index >= 0) { //多个痰喘会发生-1找不到的情况
                  return this.data.compArr.splice(index,
          1);
                }
              },
              this: this
            });
          })
        ])
      ]);
    }
  }
};
