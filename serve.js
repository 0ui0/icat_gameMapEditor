// Generated by CoffeeScript 2.6.1
var Hapi, cfg1, config, init, pathLib, server1;

Hapi = require("@hapi/hapi");

pathLib = require("path");

config = require("./config");

cfg1 = {
  port: config.port,
  host: config.host,
  state: {
    //strictHeader: false #非严格解析cookie
    ignoreErrors: true
  },
  routes: {
    files: {
      relativeTo: pathLib.resolve("www")
    }
  }
};

server1 = new Hapi.server(cfg1);

init = async function(server) {
  // plugins
  await server.register(require("@hapi/inert"));
  await server.register(require("@hapi/vision"));
  
  // vision
  server.views({
    engines: {
      js: {
        compile: (fileStr, opt) => {
          var data, err, render;
          try {
            if (!global.window) {
              global.window = global.document = global.requestAnimationFrame = void 0;
            }
            global.m = require("mithril");
            render = require("mithril-node-render");
            data = require(opt.filename);
            return (context) => {
              var html;
              html = render.sync(data, context);
              return "<!DOCTYPE html>" + html;
            };
          } catch (error) {
            err = error;
            return console.log(err);
          }
        }
      }
    },
    relativeTo: __dirname,
    path: "render"
  });
  // all routes
  await server.route({
    method: 'get',
    path: "/{param*}",
    handler: {
      directory: {
        path: 'dist'
      }
    },
    options: {
      auth: false
    }
  });
  await server.route({
    method: "get",
    path: "/",
    handler: function(req, h) {
      return h.view("index");
    }
  });
  // start server
  await server.start();
  return console.log(`server start at ${server.info.uri}`);
};

(async function() {
  var err;
  try {
    //启动服务器
    return (await init(server1));
  } catch (error) {
    err = error;
    return console.log(err);
  }
})();
