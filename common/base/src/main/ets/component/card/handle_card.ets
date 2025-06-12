
@Component
export struct HandleCardNormal{

  @Require title:string =""
  @Require text:string =""
  @Require IHeight:number= 0
  bgColor?:[ResourceColor,number][] = [["#9966bb",0],["#6699bb",1]]
  clickCallBack=()=>{}
  build() {
    Column({space:5}){
      Text(this.title)
        .fontSize($r("app.float.handleCardNormal_title"))
        .fontColor($r("app.color.handleCardNormal_title_font"))
        .width("100%")
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .ellipsisMode(EllipsisMode.END)
        .textOverflow({overflow:TextOverflow.Ellipsis})
      Text(this.text)
        .fontSize($r("app.float.handleCardNormal_text"))
        .fontColor($r("app.color.handleCardNormal_text_font"))
        .width("100%")
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .ellipsisMode(EllipsisMode.END)
        .textOverflow({overflow:TextOverflow.Ellipsis})
        .padding({left:5,right:5})
    }
    .width(this.IHeight)
    .aspectRatio(1)
    .borderRadius(10)
    .justifyContent(FlexAlign.Center)
    .linearGradient({
      angle:45,
      colors:this.bgColor
    })
    .onClick(()=>{
      this.clickCallBack()
    })
  }
}