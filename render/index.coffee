config = require "../config"
module.exports =
  view:->
    m "html",[
      m "head",[
        m "title",config.title or "宅喵地图编辑器"
        m "meta[charset=utf-8]"
        m "meta",
          name:"viewport"
          content:"width=device-width, initial-scale=1.0, user-scalable=no"
        m "link",
          rel:"stylesheet"
          href:"https://cdn.staticfile.org/animate.css/3.7.2/animate.min.css"
        m "base",
          href:"/"
        m "style","""
          html {
              font-size: 10px;
              font-weight: 500;
              height: 100%;
              position: relative;
              overflow: hidden;
          }

          * {
              font-size: 1.4rem;
              font-family: 'Noto Sans SC', PingFangSC, PingFangSC-Regular, 'Microsoft YaHei', 微软雅黑, STXihei, 华文细黑, Georgia, 'Times New Roman', serif;
          }

          body {
              margin: 0;
              padding: 0;
              height: 100%;
              position: relative;
              overflow: auto;
          }

          #home {
              height: 100%;
              /*
              background-image: url("./statics/zone_bg.jpg");
              background-size: cover;
              */
          }

          a {
              text-decoration: none;
              color: hsl(205, 100%, 50%)
          }

          a:hover {
              color: hsl(200, 100%, 50%);
              cursor: pointer;
          }

          @media only screen and (max-width : 768px) {
              html {
                  font-size: 10px
              }
          }

        """
      ]
      m "body",[
        m "#home",[
          m "script",
            type:"module"
            src:"/assets/main.js?v=#{Date.now()}"
        ]
      ]
    ]