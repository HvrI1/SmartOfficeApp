import { HMRouter } from '@hadss/hmrouter'
import { BacKNav } from 'base'
import { TabClass } from '../../pojo'
import { MeetingCheckList } from './MeetingCheckList'
import { MeetingFinishList } from './MeetingFinishList'
import { MeetingSubscribeList } from './MeetingSubscribeList'

@HMRouter({pageUrl:"MeetingSubscribeComp"})
@Component
export  struct MeetingSubscribe {

  //状态：当前选中的下标
  @State currentIndex:number=0
  //状态：tab选项卡数据
  @State tabList:TabClass[] = [
    {
      title:"预约列表",
      name:"list"
    },
    {
      title:"待审核",
      name:"waiting"
    },
    {
      title:"已通过",
      name:"finish"
    }
  ]

  //组件：tabs选项卡单项
  @Builder
  getTabBar(item:TabClass,index:number){
    Text(item.title)
      .padding(10)
      .border({width:{bottom:this.currentIndex===index?3:0},color:$r("app.color.MeetingSubscribe_tab_bar_border")})
  }


  build() {
    Column(){
      BacKNav({
        title:"会议预约",
        isShowBack:true
      })
      Tabs({index:$$this.currentIndex,barPosition:BarPosition.Start}){
        ForEach(this.tabList,(item:TabClass,index:number)=>{
          TabContent(){
            if(item.name==="list"){
              //TODO:预约列表
              MeetingSubscribeList()
            }else if(item.name==="waiting"){
              //TODO:待审核列表
              MeetingCheckList()
            }else {
              //TODO:已完成列表
              MeetingFinishList()
            }
          }
          .tabBar(this.getTabBar(item,index))
        })
      }

    }
    .width("100%")
    .height("100%")
  }
}