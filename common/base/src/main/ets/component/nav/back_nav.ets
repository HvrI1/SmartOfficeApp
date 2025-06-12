import { HMRouterMgr } from "@hadss/hmrouter"

@Component
export struct BacKNav{

  title:string = ""
  isShowBack:boolean = true
  isShowSearch:boolean = false

  searchCallBack=()=>{}

  build() {
    Stack({alignContent:Alignment.Start}){
      Row(){
        Text(this.title)
          .fontSize($r("app.float.nav_title_text"))
          .fontColor($r("app.color.nav_title_text_font"))
          .fontWeight(FontWeight.Bold)
      }
      .width("100%")
      .height("100%")
      .justifyContent(FlexAlign.Center)

      Row(){
        if(this.isShowBack){
          SymbolGlyph($r("sys.symbol.chevron_left"))
            .fontSize($r("app.float.nav_glyph"))
            .onClick(()=>{
              HMRouterMgr.pop()
            })
        }else {
          Row()
        }
        if(this.isShowSearch){
          SymbolGlyph($r("sys.symbol.magnifyingglass"))
            .fontSize($r("app.float.nav_glyph"))
            .onClick(()=>{
              this.searchCallBack()
            })
        }else {
          Row()
        }
      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width("100%")
    .height(50)
    .padding(10)
  }
}