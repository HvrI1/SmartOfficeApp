export class TabClass{
  title:string = ""
  name:string = ""
  icon?:ResourceStr
  color?:ResourceColor
}

export class HandleCardClass{
  title:string =""
  text:string =""
  bgColor?:[ResourceColor, number][]
}

export class WorkCardClass{
  icon:Resource = $r("sys.symbol.picture_damage")
  text:string =""
  iconColor:string = ""
}


export class WebAddressResp{
  name:string = ""
  address:string =""
  distance:number =0
}