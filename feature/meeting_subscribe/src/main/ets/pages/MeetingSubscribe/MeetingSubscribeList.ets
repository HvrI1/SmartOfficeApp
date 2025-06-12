import { queryAllMeetingRoomApi, subscribeMeetingApi } from "../../api"
import { MeetingRoomInfo, SubscribeMeetingDDDInfo } from "../../pojo"
import { promptAction } from "@kit.ArkUI"
import { MeetingSubscribeDiaLog } from "./MeetingSubscribeDiaLog"
import { ListDataSource, SimpleLoading } from "base"

@Component
export struct MeetingSubscribeList{
  lazyDataSource:ListDataSource = new ListDataSource()
  //状态：显示会议室list列表的数据源
  @State  @Watch("updateDataSource") meetingRoomList:MeetingRoomInfo[] = []
  //当原始数据发生
  updateDataSource(){
    this.lazyDataSource.reloadData(this.meetingRoomList)
  }
  //状态：双向同步refresh组件的状态
  @State refreshing:boolean = false

  //记录当前组件刷新的状态
  @State refreshStatus: RefreshStatus = RefreshStatus.Inactive

  //属性：弹窗控制器
  private controller?:CustomDialogController

  //遮罩动画
  layer:CustomDialogController = new CustomDialogController({
    builder: SimpleLoading({loadingText: '预约中，请稍后...'}),
    customStyle: false,
    autoCancel: false,//非常重要,必须声明false
    alignment: DialogAlignment.Center
  })

  //组件：会议室信息单项
  @Builder
  MeetingRoomItem(item:MeetingRoomInfo,index:number){
      Row({space:10}){
        //左边图片
        Image(item.coverUrl)
          .width("30%")
          .height("100%")
          .objectFit(ImageFit.Cover)
          .borderRadius(10)
        //右边信息
        Column({space:10}){
          Text(item.building)
            .fontWeight(FontWeight.Bold)
            .fontSize($r("app.float.MeetingTabList_text_normal"))
            .width("100%")
            .textAlign(TextAlign.Start)
            .textOverflow({overflow:TextOverflow.Ellipsis})
            .ellipsisMode(EllipsisMode.END)
            .maxLines(1)
          Row(){
            Column({space:10}){
              Text("位置:"+item.roomNumber)
                .fontSize($r("app.float.MeetingTabList_text_little"))
                .fontColor($r("app.color.MeetingTabList_text_gray"))
                .width("100%")
                .textAlign(TextAlign.Start)
                .textOverflow({overflow:TextOverflow.Ellipsis})
                .ellipsisMode(EllipsisMode.END)
                .maxLines(1)
              Text("可容纳:"+item.capacity+"人")
                .fontSize($r("app.float.MeetingTabList_text_little"))
                .fontColor($r("app.color.MeetingTabList_text_gray"))
                .width("100%")
                .textAlign(TextAlign.Start)
                .textOverflow({overflow:TextOverflow.Ellipsis})
                .ellipsisMode(EllipsisMode.END)
                .maxLines(1)
            }
            .layoutWeight(1)
            Row(){
              Text("预约")
                .width(60)
                .padding(10)
                .borderRadius(10)
                .backgroundColor($r("app.color.MeetingTabList_button_background"))
                .fontColor($r("app.color.MeetingTabList_button_font"))
                .textAlign(TextAlign.Center)
            }
            .width("30%")
            .justifyContent(FlexAlign.End)
            .onClick(()=>{
              //TODO:执行预约
              this.execSubscribe(item)
            })
          }
          .width("100%")
          .layoutWeight(1)
        }
        .layoutWeight(1)
      }
      .width("95%")
      .height(100)
      .padding(15)
      .borderRadius(10)
      .backgroundColor($r("app.color.MeetingTabList_background_white"))
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

  execSubscribe(item:MeetingRoomInfo){
    //弹窗填写信息
    this.controller = new CustomDialogController({
      builder:MeetingSubscribeDiaLog({
        meetingRoomInfo:item,
        clickCallBack:async (subscribeMeetingDDDModel:SubscribeMeetingDDDInfo)=>{
          //打开动画
          this.layer.open()
          //调用接口插入
          const res = await subscribeMeetingApi(subscribeMeetingDDDModel)
          if(res.code===200){
            //插入成功
            promptAction.showToast({message:res.message})
          }else {
            promptAction.showToast({message:res.message})
          }
          this.controller?.close()
          this.layer.close()
          // this.controller?.close()
        }
      })
    })
    //弹窗
    this.controller.open()


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

  //方法：查询所有的会议室数据
  async queryAllMeetingRoom(){
    const res =  await queryAllMeetingRoomApi();
    if(res.code===200){
      this.meetingRoomList=res.data as MeetingRoomInfo[]
      this.refreshing = false
    }else {
      promptAction.showToast({message:"查询会议室列表失败"})
    }
  }

  aboutToAppear(): void {
    //查询所有的会议室数据
    this.queryAllMeetingRoom()
  }


  build() {
    Refresh({refreshing:$$this.refreshing,builder: this.getRefreshDisplay}){
      List({space:5}){
        LazyForEach(this.lazyDataSource,(item:MeetingRoomInfo,index:number)=>{
          ListItem(){
            //会议室item单项
            this.MeetingRoomItem(item,index)
          }
        })
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
        this.queryAllMeetingRoom()
      }else if(value === RefreshStatus.Done){
        promptAction.showToast({message:"刷新完成"})
      }

    })
  }
}