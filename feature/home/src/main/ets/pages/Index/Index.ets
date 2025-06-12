import { TabClass } from '../../pojo'
import { House } from './House'
import { Contacts } from './Contacts'
import { Mine } from './Mine'
import { Work } from './Work'
import { HMRouter } from '@hadss/hmrouter'
import { BreakpointConstants, CommonConstants } from 'base'

@HMRouter({ pageUrl: 'IndexComp' ,interceptors:["LoginCheckInterceptor"]})
@Component
export  struct Index {


  @StorageProp(BreakpointConstants.CURRENT_BREAKPOINT)
  currentBreakPoint:string = "sm"

  //tab的数据
  tabList:TabClass[] = [
    {
      title: "首页",
      name: "house",
      icon:$r("sys.symbol.house")
    },
    {
      title: "工作台",
      name: "work",
      icon:$r("sys.symbol.square_grid_2x2")
    },
    {
      title: "通讯录",
      name: "contacts",
      icon:$r("sys.symbol.ellipsis_message")
    },
    {
      title: "我的",
      name: "mine",
      icon:$r("sys.symbol.person")
    },
  ]

  //状态：tabs当前选中的下标
  @State
  currentIndex:number = 0

  //tabs的按钮导航
  @Builder
  getTabBar(item:TabClass,index:number){
    Column(){
      SymbolGlyph(item.icon as Resource)
        .fontSize($r("app.float.tabs_glyph"))
        .fontColor(this.currentIndex === index?[$r("app.color.tabs_glyph_true_font")]:[$r("app.color.tabs_glyph_false_font")])
      Text(item.title)
        .fontSize($r("app.float.tabs_title"))
        .fontColor(this.currentIndex === index?$r("app.color.tabs_glyph_true_font"):$r("app.color.tabs_glyph_false_font"))
    }
  }



  build() {
    Column(){
      //tabs区域
      Tabs({barPosition:this.currentBreakPoint==="lg"?BarPosition.Start:BarPosition.End,index:$$this.currentIndex}){
        ForEach(this.tabList,(item:TabClass,index:number)=>{
         TabContent(){
           if(item.name==="house"){
             //首页Content
             House()
           }else if(item.name === "work"){
             //工作台Content
             Work()
           }else if(item.name === "contacts"){
             //消息Content
             Contacts()
           }else {
             //我的Content
             Mine()
           }
         }
         .tabBar(this.getTabBar(item,index))
        })
      }
      .barBackgroundColor($r("app.color.tabs_bar_background"))
      .vertical(this.currentBreakPoint==="lg"?true:false)
    }
    .width("100%")
    .height("100%")
  }
}