@Component
export struct FoldNav{

  //属性：标题
  @Require title:string = ""
  //是否显示左边的icon，父子单项同步。当没有子组件就不显示
  @Prop isShowLeftIcon?:boolean = true

  //是否展开
  @State private isShowContent:boolean = true

  @BuilderParam
  Content:()=>void
  build() {
    Column({space:10}){
      Row({space:10}){
       Image($r("app.media.more_icon"))
         .width(17)
         .aspectRatio(1)
        Text(this.title)
          .fontSize($r("app.float.FoldNav_title"))
        Blank()
        SymbolGlyph(this.isShowContent?$r("sys.symbol.chevron_down"):$r("sys.symbol.chevron_right"))
          .fontSize($r("app.float.FoldNav_glyph"))
          .onClick(()=>{
            this.isShowContent=!this.isShowContent
          })
      }
      .width("100%")
      if(this.isShowContent){
        this.Content()
      }
    }
    .width("100%")
    .padding({left:15})
  }
}