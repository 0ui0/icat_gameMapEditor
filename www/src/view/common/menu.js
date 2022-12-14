// Generated by CoffeeScript 2.6.1
import Box from "./box";

export default function() {
  return {
    data: {
      show: false,
      items: []
    },
    oninit: function({attrs}) {
      if (attrs.show != null) {
        return this.data.show = attrs.show;
      }
    },
    view: function({attrs, children}) {
      return m("", [
        this.data.show ? m(Box,
        {
          tagName: ".animated.fadeIn",
          color: "white",
          style: {
            display: "flex",
            flexDirection: "column",
            padding: 0,
            boxShadow: "0 0 1rem rgba(0,0,0,0.3)",
            ...attrs.style
          },
          oncreate: ({dom}) => {
            var fnClick;
            return document.addEventListener("click",
        fnClick = () => {
              this.data.show = false;
              document.removeEventListener("click",
        fnClick);
              return m.redraw();
            });
          },
          ...attrs.ext
        },
        [...children]) : void 0
      ]);
    }
  };
};
