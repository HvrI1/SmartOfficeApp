@Component
export struct TitleNav{

  //属性（必传）:标题
  @Require title:string = ""

  //属性（必传）:是否显示icon
  @Require isShowIcon:boolean = false

  build() {
    Row(){
      Text(this.title)
        .fontSize($r("app.float.nav_title_text"))
        .fontWeight(FontWeight.Bold)
      Blank()
      if(this.isShowIcon){
        SymbolGlyph($r("sys.symbol.chevron_right"))
          .fontSize($r("app.float.nav_glyph"))
          .fontWeight(FontWeight.Bold)
      }
    }
    .width("100%")
    .height(40)
    .padding(10)

  }
}

@Component
export struct TitlePicNav{

  //属性（必传）:标题
  @Require title:string = ""

  //属性（必传）:是否显示icon
  @Require isShowIcon:boolean = false

  icon?:Resource = $r("sys.symbol.truck_box_fill")
  iconColor?:ResourceColor=""

  clickCallBack=()=>{}

  build() {
    Row({space:10}){
      SymbolGlyph(this.icon)
        .fontSize(25)
        .fontColor([this.iconColor])
      Text(this.title)
        .fontSize($r("app.float.nav_title_text_little"))
      Blank()
      if(this.isShowIcon){
        SymbolGlyph($r("sys.symbol.chevron_right"))
          .fontSize($r("app.float.nav_glyph_little"))
          .onClick(()=>{
            this.clickCallBack()
          })
      }
    }
    .width("100%")
    .height(40)
    .padding(10)

  }
}
