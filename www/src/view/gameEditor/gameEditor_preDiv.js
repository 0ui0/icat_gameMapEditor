// Generated by CoffeeScript 2.6.1
import {
  v4 as uuid
} from "uuid";

import gEData from "./gameEditor_data";

export default (class {
  constructor(obj = {
      id: uuid(),
      x: 0,
      y: 0,
      autoType: null,
      autoMain: false,
      imgX: 0,
      imgY: 0,
      imgW: gEData.getW(),
      imgH: gEData.getH(),
      url: "",
      hasBorder: 0,
      zIndex: 1,
      linkid: ""
    }) {
    var i, key, len, ref, value;
    obj.id = uuid();
    ref = Object.entries(obj);
    for (i = 0, len = ref.length; i < len; i++) {
      [key, value] = ref[i];
      this[key] = value;
    }
    if (obj.divList) {
      this.divList = obj.divList;
    }
  }

  changeId(newId) {
    checkType(arguments, ["string"], "gameEditor.PreDiv.changeId()");
    return this.id = newId;
  }

  del() {
    return this.divList.data = this.divList.data.filter((preDiv) => {
      return preDiv.id !== this.id;
    });
  }

  select(level) { //选中
    return this.hasBorder = level;
  }

  cancelSelect() {
    return this.hasBorder = 0;
  }

  setZIndex(zIndex) {
    checkType(arguments, ["number"], "gameEditor.DivList.setZIndex()");
    return this.zIndex = zIndex;
  }

  zIndexIncrease() {
    return this.zIndex += 5;
  }

  zIndexDecrease() {
    return this.zIndex -= 5;
  }

  copy() {
    var copyDiv;
    copyDiv = {...this};
    copyDiv.id = uuid();
    copyDiv.x += gEData.getW();
    copyDiv.y += gEData.getH();
    return this.divList.add(copyDiv);
  }

  linkTo(linkid) {
    checkType(arguments, ["string"], "gameEditor.PreDiv.linkTo()");
    return this.linkid = linkid;
  }

});
