@Component
export struct NoticeCard{
  @Require text:string = ""
  @Require img:ResourceStr =""
  @Require date:string = ""
  @Require viewNum:number = 0
  @Require IHeight:number = 0

  clickCallBack=()=>{}

  build() {
    Column(){
      Row(){
        //左边图片
        Row(){
          Image(this.img)
            .width("100%")
            .height("100%")
            .borderRadius(10)
        }
        .width("30%")
        .height("100%")
        //右边内容
        Column(){
          Text(this.text)
            .width("100%")

            .fontSize($r("app.float.NoticeCard_text"))
            .maxLines(2)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .ellipsisMode(EllipsisMode.START)
            .textAlign(TextAlign.Start)
            .onClick(()=>{
              //点击文字回调
              this.clickCallBack()
            })
          Row(){
            Text(this.date)
              .fontSize($r("app.float.NoticeCard_date_viewnum"))
              .fontColor($r("app.color.NoticeCard_date_viewnum_font"))
            Row(){
              SymbolGlyph($r("sys.symbol.eye"))
                .fontSize($r("app.float.NoticeCard_glyph"))
                .fontColor([$r("app.color.NoticeCard_date_viewnum_font")])
              Text(this.viewNum+"")
                .fontSize($r("app.float.NoticeCard_date_viewnum"))
                .fontColor($r("app.color.NoticeCard_viewnum_font"))
            }
          }
          .width("100%")
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .padding({left:10,right:10})
        .layoutWeight(1)
        .height("100%")
        .justifyContent(FlexAlign.SpaceBetween)
      }
    }
    .width("100%")
    .height(this.IHeight)
    .padding(10)
    .borderRadius(10)
    .backgroundColor($r("app.color.card_background"))
  }
}