
curry = (fn,args...)->
  if args.length < fn.length
    return (args1...)->
      curry(fn,args...,args1...)
  else
    fn args...


# 函数式 二维向量工具库
vectorTools = (operaFn)->
  output =
    xy:->
      new: (x,y)->{x:x,y:y}
      plus: (vec1={x:0,y:0},vec2={x:0,y:0})-> {x:vec1.x+vec2.x,y:vec1.y+vec2.y}
  operaFn(output)
  return output

# 函数式，扩展工具库到三维向量（继承）
vectorToolsBetter = vectorTools (output)->
  output.xyz = 
    new: (x,y,z)-> 
      vec = output.xy.new(x,y)
      vec.z = z
      return vec
    plus:(vec1,vec2,vec3)-> 
      vec4 = output.xy.plus(vec1,vec2)
      return output.xy.plus(vec4,vec3)

v1 = vectorTools().xy.new(4,5)
v2 = vectorTools().xy.new(8,8)
v3 = vectorTools().xy.new(v1,v2)
console.log(v3)





  



console.log(plusVector(newVecotr(5,6),newVector(7,8)))
