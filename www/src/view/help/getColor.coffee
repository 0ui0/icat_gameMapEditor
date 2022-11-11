import colorObj from "./colorObj"

export default (colorStr)-> 
  #技术宅使用蓝色
  if location.href.match /icat\.gn00\.com/g
      colorObj.yellow = 
        back:"#5683C5"
        front:"#fff"
        
  if colorObj[colorStr]
    return colorObj[colorStr]
  else
    return 
      back:"#eee"
      front:"#333"
  

  ###
  return
    back:switch colorStr
      when "none" then "transparent"
      when "red" then "#F06258" #bb4344
      when "deepRed" then "#a5000c"
      when "dark" then "#333333" 
      when "yellow" then "#ffdb66" #ffdb66
      when "sliver" then "#c0c0c0" 
      when "black" then "#000000" 
      when "white" then "#ffffff" 
      when "green" then "#23D4B2" #23d4b2
      when "deepYellow" then "#ab8829"
      when "deepBlue" then "#5171b3"
      when "lightGray" then "#eeeeee"
      when "brown" then "#594F4C"
      else "#eeeeee"
    front:switch colorStr
      when "none" then "not specified"
      when "red" then "#ffffff"
      when "deepRed" then "#ffffff"
      when "dark" then "#ffffff" 
      when "yellow" then "#5f4905" 
      when "sliver" then "#333333" 
      when "black" then "#ffffff" 
      when "white" then "#333333" 
      when "green" then "#ffffff"
      when "deepYellow" then "#ffffff"
      when "deepBlue" then "#ffffff"
      when "lightGray" then "#333333"
      when "brown" then "#ffffff"
      else "#000000"
  ###