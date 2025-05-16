import { IBestCountTo } from "@ibestservices/ibest-ui"

@Preview
@Component
export struct ProgressCard{

  //状态:父子传递
  @Prop total:number = 100
  @Prop currentValue:number = 60

  //属性：标题
  @Require title:string = "未知"

  build() {
    Column({space:10}){
      Stack({alignContent:Alignment.Center}){
        Progress({total:this.total,value:this.currentValue,style:ProgressStyle.Ring})
          .width("100%")
          .aspectRatio(1)
          .style({strokeWidth:10})

        IBestCountTo({
          start: 0,
          end: this.currentValue,
          duration:5000,
          fontSize:25
        })
      }
      .width("100%")
      Text(this.title)
        .width("100%")
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
    }
    .width(120)
    .padding(20)
    .borderRadius(15)
  }

}