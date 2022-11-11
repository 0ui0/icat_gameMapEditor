import Box from "./box"
import getColor from "../help/getColor"
import Comp from "./noticeComp"


export default
  data:
    compArr:[]
    show:false

  launch:(obj)->
    checkType arguments,["object"],"Notice.launch(obj)"
    comp = Comp(obj)
    # 如果组件已经有了，就不再添加
    unless @data.compArr.find (item)=>item.sign is obj.sign
      @data.compArr = [comp,@data.compArr...]
    @data.show = true
    m.redraw()

  view: ->
    _this = this
    if @data.show
      m "",
        style:
          zIndex: 9999999999999
          position: "fixed" 
          top: 0
          bottom: 0
          left: 0
          right: 0
          maxHeight:"100vh"
          background: "rgba(0,0,0,0.5)"
          alignItems: "center"
          boxShadow:"0.1rem 0.1rem 1rem rgba(0,0,0,0.5)"        
      ,[
        m "",
          style:
            width:"100%"
            height:"100%"
            display:"flex" if @data.compArr.length <= 2
            flexDirection:if Mob then "row" else "column"
            flexWrap:"wrap"
            justifyContent:"center" 
            alignItems:"center"
            overflow:"auto"
        ,[
          @data.compArr.map (item,index)=>
            m item,
              compArr:@data.compArr
              key: item.sign or index
              closeLayer:=>
                if @data.compArr.length is 0
                  @data.show = false
              delete:=>
                #添加元素后会导致index变化，可能会删除错误
                #所以需要重新查找正确的index
                index = @data.compArr.indexOf(item)
                ###
                console.log index
                console.log @data.compArr
                setTimeout =>
                  console.log @data.compArr
                ,500
                ###
                
                if index >= 0 #多个痰喘会发生-1找不到的情况
                  @data.compArr.splice index,1
              this:@
        ]
      ]
      

      