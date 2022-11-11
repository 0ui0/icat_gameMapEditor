Hapi = require "@hapi/hapi"
pathLib = require "path"
config = require "./config"

cfg1 =
  port: config.port
  host: config.host
  state:
    #strictHeader: false #非严格解析cookie
    ignoreErrors: true
  routes:
    files:
      relativeTo: pathLib.resolve "www"

server1 = new Hapi.server cfg1


init = (server)->
    # plugins
    await server.register require "@hapi/inert"
    await server.register require "@hapi/vision"
    

    # vision
    server.views
      engines:
        js:
          compile:(fileStr,opt)=>
            try
              if not global.window
                global.window = global.document = global.requestAnimationFrame = undefined
              global.m = require "mithril"
              render = require "mithril-node-render"
              data = require opt.filename

              return (context)=> 
                html = render.sync data,context 
                return "<!DOCTYPE html>" + html 
            catch err
              console.log err

      relativeTo:__dirname
      path:"render"


    # all routes
    await server.route
      method:'get'
      path:"/{param*}"
      handler:
        directory:
          path:'dist'
      options:
        auth:false

    await server.route
      method:"get"
      path:"/"
      handler:(req,h)->
        return h.view "index"

    # start server
    await server.start()
    console.log "server start at #{server.info.uri}"


do ->
  try
      #启动服务器
      await init(server1)
  catch err
    console.log err
