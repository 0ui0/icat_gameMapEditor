// Generated by CoffeeScript 2.6.1
var curry, v1, v2, v3, vectorTools, vectorToolsBetter;

curry = function(fn, ...args) {
  if (args.length < fn.length) {
    return function(...args1) {
      return curry(fn, ...args, ...args1);
    };
  } else {
    return fn(...args);
  }
};

// 函数式 二维向量工具库
vectorTools = function(operaFn) {
  var output;
  output = {
    xy: function() {
      return {
        new: function(x, y) {
          return {
            x: x,
            y: y
          };
        },
        plus: function(vec1 = {
            x: 0,
            y: 0
          }, vec2 = {
            x: 0,
            y: 0
          }) {
          return {
            x: vec1.x + vec2.x,
            y: vec1.y + vec2.y
          };
        }
      };
    }
  };
  operaFn(output);
  return output;
};

// 函数式，扩展工具库到三维向量（继承）
vectorToolsBetter = vectorTools(function(output) {
  return output.xyz = {
    new: function(x, y, z) {
      var vec;
      vec = output.xy.new(x, y);
      vec.z = z;
      return vec;
    },
    plus: function(vec1, vec2, vec3) {
      var vec4;
      vec4 = output.xy.plus(vec1, vec2);
      return output.xy.plus(vec4, vec3);
    }
  };
});

v1 = vectorTools().xy.new(4, 5);

v2 = vectorTools().xy.new(8, 8);

v3 = vectorTools().xy.new(v1, v2);

console.log(v3);

console.log(plusVector(newVecotr(5, 6), newVector(7, 8)));
