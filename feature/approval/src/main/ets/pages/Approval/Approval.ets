import { BacKNav, CommonConstants, ListDataSource, ProgressCard, SimpleLoading } from 'basic'
import { execApprovalApi, getAffairApi } from '../../api';
import { AffairInfo, ApprovalDto, ApprovalNumInfo, ApprovalNumModel } from '../../pojo';
import { promptAction } from '@kit.ArkUI';
import { ApprovalDialog } from './ApprovalDialog';
import { HMRouter } from '@hadss/hmrouter';


@HMRouter({ pageUrl: 'ApprovalComp' })
@Component
export  struct Approval {

  //属性：操作lazyForeach数据源的对象ListDataSource
  lazyDataSource:ListDataSource = new ListDataSource()
  //状态：当前所有事务的数据
  @State @Watch("updateDataSource") affairWaitingList:AffairInfo[] = []
  //当原始数据发生
  updateDataSource(){
    this.lazyDataSource.reloadData(this.affairWaitingList)
    // this.lazyDataSource.
  }

  //状态：当前事务类型数量展示
  @StorageLink(CommonConstants.APP_STORAGE_USER_AFFAIR_NUM)
  approvalNumData:ApprovalNumInfo = new ApprovalNumModel({
    currentAllAffairNum:0,
    currentWaitingNum:0,
    currentFinishNum:0,
    currentRejectNum:0
  } as ApprovalNumInfo)

  //状态：双向同步refresh组件的状态
  @State refreshing:boolean = false

  //记录当前组件刷新的状态
  @State refreshStatus: RefreshStatus = RefreshStatus.Inactive

  private controller?:CustomDialogController

  //遮罩动画
  layer:CustomDialogController = new CustomDialogController({
    builder: SimpleLoading({loadingText: '审核中，请稍后...'}),
    customStyle: false,
    autoCancel: false,//非常重要,必须声明false
    alignment: DialogAlignment.Center
  })


  //组件：会议室审核信息单项
  @Builder
  AffairWaitingItem(item:AffairInfo,index:number){
    Row(){
      Column({space:5}){
        Text(item.applyReason)
          .fontWeight(FontWeight.Bold)
          .fontSize($r("app.float.MeetingTabList_text_normal"))
          .width("100%")
          .textAlign(TextAlign.Start)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .ellipsisMode(EllipsisMode.END)
          .maxLines(1)
        Text("创建时间:"+item.createTime)
          .fontSize($r("app.float.MeetingTabList_text_little"))
          .fontColor($r("app.color.MeetingTabList_text_gray"))
          .width("100%")
          .textAlign(TextAlign.Start)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .ellipsisMode(EllipsisMode.END)
          .maxLines(1)
        Text("更新时间:"+item.updateTime)
          .fontSize($r("app.float.MeetingTabList_text_little"))
          .fontColor($r("app.color.MeetingTabList_text_gray"))
          .width("100%")
          .textAlign(TextAlign.Start)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .ellipsisMode(EllipsisMode.END)
          .maxLines(1)
      }
      .width("80%")

      Column({space:10}){
        Text("进行审核")
          .padding(10)
          .borderRadius(10)
          .backgroundColor($r("app.color.button_login_background"))
          .fontColor($r("app.color.button_login_font"))
          .fontSize($r("app.float.MeetingCheckList_check_state_font"))
          .onClick(()=>{
            //执行审核操作
            this.execApproval(item)
          })

      }
        .width("20%")

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

  //异步：执行审核操作
  async execApproval(item:AffairInfo){
    //弹窗显示详细信息
    this.controller = new CustomDialogController({
      builder:ApprovalDialog({
        item:item,
        clickCallBack:async (meetingSubscribeId:number,affairId:number,affairStatus:number,meetingSubscribeStatus:number)=>{
          //打开动画
          try {
            this.layer.open()
            const res =  await execApprovalApi({
              meetingSubscribeId,
              affairId,
              affairStatus,
              meetingSubscribeStatus
            } as ApprovalDto)
            if(res.code===200){
              promptAction.showToast({message:res.message})
            }else {
              promptAction.showToast({message:res.message})
            }
            this.layer.close()
            this.controller?.close()
            this.refresh()
          }catch (e) {
           promptAction.showToast({message:"审核操作失败,请联系管理员"})
            this.layer.close()
            this.controller?.close()
            this.refresh()
          }
        }
      })
    })
    //弹窗
    this.controller.open()
  }



  //方法：计算总数，待办和拒绝的数量
  computeAffairTypeNum(affairInfoList:AffairInfo[]){
    console.log(JSON.stringify(affairInfoList))
    affairInfoList.forEach((item:AffairInfo,index:number)=>{
      if(item.status === "待办") this.approvalNumData.currentWaitingNum++
      if(item.status === "已完成") this.approvalNumData.currentFinishNum++
      if(item.status === "拒绝") this.approvalNumData.currentRejectNum++
      this.approvalNumData.currentAllAffairNum++

    })
  }

  //方法：过滤待办列表
  filterWaitingList(affairInfoList:AffairInfo[]){
    affairInfoList.forEach((item:AffairInfo,index:number)=>{
      if(item.status === "待办") this.affairWaitingList.push(item)
    })
  }

  //请求所有的事务数据
  async getAllAffairData(){
    const res =  await getAffairApi()
    if(res.code===200){
      //调用过滤待办列表
      this.filterWaitingList(res.data as AffairInfo[])
      //调用计算总数，待办和拒绝的数量
      this.computeAffairTypeNum(res.data as AffairInfo[])
    }else {
      promptAction.showToast({message:res.message})
    }
  }

  //刷新操作
  refresh(){
    //清空数据
    this.affairWaitingList = []
    this.approvalNumData = new ApprovalNumModel({
      currentAllAffairNum:0,
      currentWaitingNum:0,
      currentFinishNum:0,
      currentRejectNum:0
    } as ApprovalNumInfo)

    //请求数据
    this.getAllAffairData().then(()=>{
      //更新刷新状态
      this.refreshing = false
    })
  }




  //声明周期
  aboutToAppear(): void {
    //页面构建时加载数据
    this.refresh()
  }

  build() {
    Column({space:10}){
      BacKNav({
        title:"我的审批",
        isShowBack:true
      })
        .backgroundColor($r("app.color.Approval_card_background_white"))

        Row(){
          ProgressCard({
            title:"待审核",
            total:this.approvalNumData.currentAllAffairNum,
            currentValue:this.approvalNumData.currentWaitingNum
          })
            .layoutWeight(1)
          ProgressCard({
            title:"已审核",
            total:this.approvalNumData.currentAllAffairNum,
            currentValue:this.approvalNumData.currentFinishNum
          })
            .layoutWeight(1)
          ProgressCard({
            title:"已拒绝",
            total:this.approvalNumData.currentAllAffairNum,
            currentValue:this.approvalNumData.currentRejectNum
          })
            .layoutWeight(1)
        }
        .width("95%")
        .backgroundColor($r("app.color.Approval_card_background_white"))
        .borderRadius(10)
      Refresh({refreshing:$$this.refreshing,builder: this.getRefreshDisplay}){
        List(){
          LazyForEach(this.lazyDataSource,(item:AffairInfo,index:number)=>{
            ListItem(){
              this.AffairWaitingItem(item,index)
            }
          })
        }
        .alignListItem(ListItemAlign.Center)
        .width('100%')
      }
      .layoutWeight(1)
      .onStateChange((value:RefreshStatus)=>{
        //更新
        this.refreshStatus = value
        if(value === RefreshStatus.Refresh){
          //刷新数据
          this.refresh()
        }else if(value === RefreshStatus.Done){
          promptAction.showToast({message:"刷新完成"})
        }

      })


    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.page_background_normal"))
  }
}



