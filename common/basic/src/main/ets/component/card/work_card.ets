@Component
export struct WorkCardNormal{

  @Require icon:Resource = $r("sys.symbol.picture_damage")
  @Require text:string =""
  @Require iconColor:string = ""
  clickCallBack=()=>{}

  build() {
    Column({space:5}){
      Row(){
        SymbolGlyph(this.icon)
          .fontSize($r("app.float.WorkCardNormal_glyph"))
          .fontColor([this.iconColor])
      }
      .padding(10)
      .borderRadius(10)
      .backgroundColor('#' + '30' + this.iconColor.slice(1))

      Text(this.text)
        .fontSize($r("app.float.WorkCardNormal_text"))
    }
    .width(70)
    .aspectRatio(1)
    .justifyContent(FlexAlign.Center)
    .onClick(()=>{
      this.clickCallBack()
    })
  }
}