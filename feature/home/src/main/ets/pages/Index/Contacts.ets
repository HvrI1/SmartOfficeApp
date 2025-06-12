import { CommonConstants, FoldNav, TitleNav } from "base"

@Component
export struct Contacts{
  @StorageProp(CommonConstants.AVOID_RECT_HEIGHT_TOP)
  avoidTopHeight:number = 0

  //属性：组织内数据循环
  organizationList:string[]=["校领导","党政办公室","教师发展中心","教师工作部，人事部","学生管理工作部","外国语学院","外国语学院","管理学院","美术设计学院"]






  //组件：
  @Builder
  OrganizationItem(item:string){

  }


  build() {
    Column({space:15}){
      //搜索页面
      Search({placeholder:"搜索"})
        .width("90%")
        .height(30)
        .onSubmit((value:string)=>{
          //搜索回调
        })
      //好友卡片区域
      Column({space:10}){
        Row({space:5}){
          Image($r("app.media.new_friend"))
            .width(20)
            .aspectRatio(1)
            .borderRadius(5)
          Text("新的好友")
            .fontSize($r("app.float.title_text"))
          Blank()
          SymbolGlyph($r("sys.symbol.chevron_right"))
            .fontSize($r("app.float.Contacts_card_glyph"))
            .fontWeight(FontWeight.Bold)
            .onClick(()=>{
              //新的好友回调
            })
        }
        .width("100%")
        Divider()
        Row({space:5}){
          Image($r("app.media.my_friend"))
            .width(20)
            .aspectRatio(1)
            .borderRadius(5)
          Text("我的好友")
            .fontSize($r("app.float.title_text"))
          Blank()
          SymbolGlyph($r("sys.symbol.chevron_right"))
            .fontSize($r("app.float.Contacts_card_glyph"))
            .fontWeight(FontWeight.Bold)
            .onClick(()=>{
              //TODO:回调
            })
        }
        .width("100%")
        Divider()
        Row({space:5}){
          Image($r("app.media.my_groups"))
            .width(20)
            .aspectRatio(1)
            .borderRadius(5)
          Text("我的群组")
            .fontSize($r("app.float.title_text"))
          Blank()
          SymbolGlyph($r("sys.symbol.chevron_right"))
            .fontSize($r("app.float.Contacts_card_glyph"))
            .fontWeight(FontWeight.Bold)
            .onClick(()=>{
              //我的群组回调
            })
        }
        .width("100%")
      }
      .width("90%")
      .padding(10)
      .backgroundColor($r("app.color.Contacts_card_background"))
      .borderRadius(10)


      //组织内卡片区域
      Scroll(){
        Column({space:20}){
          Text("组织内")
            .width("100%")
            .fontColor($r("app.color.Contacts_gray"))
          Row({space:15}){
            Image($r("app.media.school_icon"))
              .width(40)
              .aspectRatio(1)
              .borderRadius(50)
            Column({space:5}){
              Text("成功学院")
                .fontSize($r("app.float.title_text"))
                .fontWeight(FontWeight.Bold)
                .width("100%")
              Text("2489人")
                .fontSize($r("app.float.title_text_little"))
                .fontColor($r("app.color.Contacts_gray"))
                .width("100%")
            }
            .layoutWeight(1)
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width("100%")
          //循环生成架构列表
          ForEach(this.organizationList,(item:string,index:number)=>{
            FoldNav({
              title:item,
              isShowLeftIcon:true,
              Content:()=>{
                this.OrganizationItem(item)
              }
            })
          })


        }
        .width("90%")
        .padding(10)
        .backgroundColor($r("app.color.Contacts_card_background"))
        .borderRadius(10)
      }
      .width("100%")




    }
    .width("100%")
    .height("100%")
    .padding({bottom:55,top:this.avoidTopHeight})
    .backgroundColor($r("app.color.page_background_normal"))
  }
}