import { selectMeetingRoomInfoApi, selectMeetingSubscribeInfoApi } from "../../api"
import { AffairInfo, MeetingRoomInfo, MeetingRoomModel, MeetingSubscribeInfo, MeetingSubscribeModel } from "../../pojo"
import { promptAction } from "@kit.ArkUI"
import { FoldNav, TitleNav } from "basic"

@CustomDialog
@Component
export struct ApprovalDialog{

  //状态：单项同步的事务
  @Prop item:AffairInfo

  //状态:显示会议预约的详情,异步加载
  @State private meetingSubscribeInfo:MeetingSubscribeInfo = new MeetingSubscribeModel({} as MeetingSubscribeInfo)

  //会议室详情
  @State private meetingRoomInfo:MeetingRoomInfo = new MeetingRoomModel({} as MeetingRoomInfo)

  private controller:CustomDialogController

  //回调给父组件
  clickCallBack=(meetingSubscribeId:number,affairId:number,status:number)=>{}



  //组件:会议室卡片
  @Builder
  getMeetingComp(){
    Column({space:5}){
      Row({space:5}){
        Text("位置:")
          .width("25%")
        TextInput({text:this.meetingRoomInfo.building})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("房间号:")
          .width("25%")
        TextInput({text:this.meetingRoomInfo.roomNumber})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("可容纳人数:")
          .width("30%")
        TextInput({text:this.meetingRoomInfo.capacity+""})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)
    }
    .width("100%")
    .padding(10)
  }
  //组件:事务卡片
  @Builder
  getAffairComp(){
    Column({space:5}){
      Row({space:5}){
        Text("预约用户:")
          .width("25%")
        TextInput({text:this.item.user})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("预约类型:")
          .width("25%")
        TextInput({text:this.item.type})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)

      Column({space:5}){
        Text("预约原因")
          .width("100%")
        TextArea({text:this.item.applyReason})
          .width("100%")
          .enabled(false)
          .height(100)
      }
      .width("100%")

    }
    .width("100%")
    .padding(10)
  }




  //组件:预约卡片
  @Builder
  getSubscribeComp(){
    Column({space:5}){
      Row({space:5}){
        Text("主题:")
          .width("25%")
        TextInput({text:this.meetingSubscribeInfo.meetingTheme})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("参会人数:")
          .width("25%")
        TextInput({text:this.meetingSubscribeInfo.participants+""})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("所属部门:")
          .width("25%")
        TextInput({text:this.meetingSubscribeInfo.department})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("会议类型:")
          .width("25%")
        TextInput({text:this.meetingSubscribeInfo.meetingType})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("开始时间:")
          .width("25%")
        TextInput({text:this.meetingSubscribeInfo.startTime})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("结束时间:")
          .width("25%")
        TextInput({text:this.meetingSubscribeInfo.endTime})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)
    }
    .width("100%")
    .padding(10)
  }




  //方法：根据事务查询对应预约的详情和会议室的详情
  async selectMeetingSubscribeInfo(){
    try {
      const meetingSubscribeRes =  await selectMeetingSubscribeInfoApi(this.item.id)
      const meetingRoomRes =  await selectMeetingRoomInfoApi(meetingSubscribeRes.data?.roomId as number )
      if(meetingRoomRes.code===200 && meetingRoomRes.code === 200){
        this.meetingSubscribeInfo =  meetingSubscribeRes.data as  MeetingSubscribeInfo
        this.meetingRoomInfo =  meetingRoomRes.data as  MeetingRoomInfo
      }else {
        promptAction.showToast({message:meetingSubscribeRes.message+meetingRoomRes.message})

      }
    }catch (e) {
      promptAction.showToast({message:"加载数据失败,稍后再试"})

      this.controller.close()
    }
  }





  //声明周期
  aboutToAppear(): void {
    this.selectMeetingSubscribeInfo()
  }

  build() {
    Scroll(){
      Column({space:10}){
        FoldNav({
          title:'提交事务信息',
          Content:()=>{
            this.getAffairComp()
          },
          isShowLeftIcon:false
        })
          .backgroundColor($r("app.color.Approval_card_background_white"))
          .borderRadius(10)
        FoldNav({
          title:'预约信息信息',
          Content:()=>{
            this.getSubscribeComp()
          },
          isShowLeftIcon:false
        })
          .backgroundColor($r("app.color.Approval_card_background_white"))
          .borderRadius(10)
        FoldNav({
          title:'会议室信息',
          Content:()=>{
            this.getMeetingComp()
          },
          isShowLeftIcon:false
        })
          .backgroundColor($r("app.color.Approval_card_background_white"))
          .borderRadius(10)

        Row({space:10}){
          Text("取 消")
            .layoutWeight(1)
            .height(50)
            .borderRadius(10)
            .fontColor($r("app.color.button_font_gray"))
            .backgroundColor($r("app.color.button_background_gray"))
            .textAlign(TextAlign.Center)
            .onClick(()=>{
              this.controller.close()
            })
          Text("拒 绝")
            .layoutWeight(1)
            .height(50)
            .borderRadius(10)
            .fontColor($r("app.color.button_font_red"))
            .backgroundColor($r("app.color.button_background_red"))
            .textAlign(TextAlign.Center)
            .onClick(()=>{
              this.clickCallBack(this.meetingSubscribeInfo.id,this.item.id,2)
            })
          Text("同 意")
            .layoutWeight(1)
            .height(50)
            .borderRadius(10)
            .fontColor($r("app.color.MeetingTabList_button_font"))
            .backgroundColor($r("app.color.MeetingTabList_button_background"))
            .textAlign(TextAlign.Center)
            .onClick(()=>{
              //回调给父组件
              this.clickCallBack(this.meetingSubscribeInfo.id,this.item.id,1)
            })
        }
        .width("90%")
      }
    }
    .width("100%")
    .height("100%")
    .padding(20)
    .backgroundColor($r("app.color.page_background_normal"))
    .align(Alignment.Top)
  }
}