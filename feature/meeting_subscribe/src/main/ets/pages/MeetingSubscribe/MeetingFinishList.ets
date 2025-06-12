import { CommonConstants, ListDataSource } from "base"
import { queryAllMeetingSubscribeInfoApi } from "../../api"
import { MeetingSubscribeInfo, User } from "../../pojo"
import { promptAction } from "@kit.ArkUI"

@Component
export struct MeetingFinishList{
  //状态：从AppStorage获取用户信息
  @StorageProp(CommonConstants.APP_STORAGE_USER)
  userInfo:User={} as User

  lazyDataSource:ListDataSource = new ListDataSource()

  //状态：显示会议室预约事务列表的数据源
  @State @Watch("updateDataSource") meetingSubscribeList:MeetingSubscribeInfo[] = []
  //当原始数据发生
  updateDataSource(){
    this.lazyDataSource.reloadData(this.meetingSubscribeList)
  }
  //状态：双向同步refresh组件的状态
  @State refreshing:boolean = false

  //记录当前组件刷新的状态
  @State refreshStatus: RefreshStatus = RefreshStatus.Inactive

  //组件：会议室预约信息单项
  @Builder
  MeetingSubscribe(item:MeetingSubscribeInfo,index:number){
      Row(){
        Column({space:5}){
          Text(item.meetingTheme)
            .fontWeight(FontWeight.Bold)
            .fontSize($r("app.float.MeetingTabList_text_normal"))
            .width("100%")
            .textAlign(TextAlign.Start)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .ellipsisMode(EllipsisMode.END)
            .maxLines(1)
          Text("部门:"+item.department)
            .fontSize($r("app.float.MeetingTabList_text_little"))
            .fontColor($r("app.color.MeetingTabList_text_gray"))
            .width("100%")
            .textAlign(TextAlign.Start)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .ellipsisMode(EllipsisMode.END)
            .maxLines(1)
          Text("参会人数:"+item.participants)
            .fontSize($r("app.float.MeetingTabList_text_little"))
            .fontColor($r("app.color.MeetingTabList_text_gray"))
            .width("100%")
            .textAlign(TextAlign.Start)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .ellipsisMode(EllipsisMode.END)
            .maxLines(1)
          Text("类型:"+item.meetingType)
            .fontSize($r("app.float.MeetingTabList_text_little"))
            .fontColor($r("app.color.MeetingTabList_text_gray"))
            .width("100%")
            .textAlign(TextAlign.Start)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .ellipsisMode(EllipsisMode.END)
            .maxLines(1)
          Text("开始时间:"+item.startTime)
            .fontSize($r("app.float.MeetingTabList_text_little"))
            .fontColor($r("app.color.MeetingTabList_text_gray"))
            .width("100%")
            .textAlign(TextAlign.Start)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .ellipsisMode(EllipsisMode.END)
            .maxLines(1)
          Text("结束时间:"+item.endTime)
            .fontSize($r("app.float.MeetingTabList_text_little"))
            .fontColor($r("app.color.MeetingTabList_text_gray"))
            .width("100%")
            .textAlign(TextAlign.Start)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .ellipsisMode(EllipsisMode.END)
            .maxLines(1)
        }
        .width("80%")

        Text(item.status)
          .width("20%")
          .aspectRatio(1)
          .borderRadius(50)
          .fontSize($r("app.float.MeetingCheckList_finish_state_font"))
          .backgroundColor(item.status==="已通过"?$r("app.color.MeetingCheckList_finish_state_background"):$r("app.color.MeetingCheckList_reject_state_background"))
          .fontColor($r("app.color.MeetingCheckList_finish_state_font"))
          .textAlign(TextAlign.Center)
      }
      .width("90%")
      .padding(15)
      .borderRadius(10)
      .backgroundColor($r("app.color.MeetingSubscribe_card_background_white"))
      .margin({top:5})
  }

  //刷新时显示的组件
  @Builder getRefreshDisplay() {
    Row() {
      LoadingProgress()
        .width(40)
        .aspectRatio(1)
        .color($r('app.color.loading_progress_color'))
      Text(this.getStatusInfo())
        .fontColor($r('app.color.loading_progress_color'))
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r("app.color.page_background_normal"))
  }

  //状态提示文本
  getStatusInfo() {
    switch (this.refreshStatus) {
      case RefreshStatus.Drag:
        return '继续下拉'
      case RefreshStatus.OverDrag:
        return '松手加载'
      case RefreshStatus.Refresh:
        return '刷新中'
      case RefreshStatus.Done:
        return '刷新完成'
      default:
        return ''
    }
  }

  //方法:查询当前用户所有的会议室预约信息
  async queryAllMeetingSubscribe(){
    if(!this.userInfo.id){
      return
    }
    const res = await queryAllMeetingSubscribeInfoApi(this.userInfo.id)
    if(res.code===200){
      this.meetingSubscribeList = res.data as MeetingSubscribeInfo[]
      this.refreshing = false
    }else {
      promptAction.showToast({message:res.message})
    }
  }

  //声明周期
  aboutToAppear(): void {
    //查询当前用户所有的会议室预约信息
    this.queryAllMeetingSubscribe()
  }

  build() {
    Refresh({refreshing:$$this.refreshing,builder: this.getRefreshDisplay}){
      List({space:5}){
        if(this.meetingSubscribeList.length===0){
          ListItem(){
            Text("------当前暂无待审核数据数据------")
              .width("100%")
              .textAlign(TextAlign.Center)
              .margin({top:50})
              .fontColor($r("app.color.Calendar_text_gray"))
          }
        }else {
          LazyForEach(this.lazyDataSource,(item:MeetingSubscribeInfo,index:number)=>{
            ListItem(){
              //会议室item单项
              this.MeetingSubscribe(item,index)
            }
          })
        }
      }
      .width("100%")
      .height("100%")
      .backgroundColor($r("app.color.page_background_normal"))
      .alignListItem(ListItemAlign.Center)
    }
    .onStateChange((value:RefreshStatus)=>{
      //更新
      this.refreshStatus = value
      if(value === RefreshStatus.Refresh){
        //刷新数据
        this.queryAllMeetingSubscribe()
      }else if(value === RefreshStatus.Done){
        promptAction.showToast({message:"刷新完成"})
      }

    })
  }
}