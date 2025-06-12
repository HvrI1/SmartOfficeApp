import dayjs from "@hview/dayjs"
import { BacKNav, CommonConstants, TitleNav } from "base"
import {
  AffairInfo,
  AffairModel,
  MeetingRoomInfo,
  MeetingRoomModel,
  MeetingSubscribeInfo,
  MeetingSubscribeModel,
  SubscribeMeetingDDDInfo, SubscribeMeetingDDDModel, User, UserModel } from "../../pojo"
import { promptAction } from "@kit.ArkUI"

@CustomDialog
export struct MeetingSubscribeDiaLog{
  private controller:CustomDialogController

  //状态：选中的会议
  @Prop meetingRoomInfo:MeetingRoomInfo


  @State showStartTime:string = ""
  @State showEndTime:string = ""

  //请求的聚合对象
  subscribeMeetingDDDModel:SubscribeMeetingDDDInfo = new SubscribeMeetingDDDModel({
    user:new UserModel({} as User),
    affair:new AffairModel({} as AffairInfo),
    meetingRoom:new MeetingRoomModel({} as MeetingRoomInfo),
    meetingSubscribe:new MeetingSubscribeModel({} as MeetingSubscribeInfo)
  } as SubscribeMeetingDDDInfo)

  //回调：把值返回给父组件
  clickCallBack =(subscribeMeetingDDDModel:SubscribeMeetingDDDInfo)=>{}


  //方法：判断是否可以点击预约
  isCanClick(){
    if(!this.subscribeMeetingDDDModel.meetingSubscribe.startTime){
      promptAction.showToast({message:"请选择开始时间"})
      return false
    }
    if(!this.subscribeMeetingDDDModel.meetingSubscribe.endTime){
      promptAction.showToast({message:"请选择结束时间"})
      return false
    }
    if(!this.subscribeMeetingDDDModel.meetingSubscribe.meetingTheme){
      promptAction.showToast({message:"请填写会议主题"})
      return false
    }
    if(!this.subscribeMeetingDDDModel.meetingSubscribe.participants){
      promptAction.showToast({message:"请输入会议人数"})
      return false
    }
    if(!this.subscribeMeetingDDDModel.meetingSubscribe.meetingType){
      promptAction.showToast({message:"请选择会议类型"})
      return false
    }
    if(!this.subscribeMeetingDDDModel.meetingSubscribe.department){
      promptAction.showToast({message:"请选择申请部门"})
      return false
    }
    if(!this.subscribeMeetingDDDModel.affair.applyReason){
      promptAction.showToast({message:"请填写申请原因"})
      return false
    }
    return true
  }

  build() {
    Column({space:10}){
      Row({space:5}){
        Text("会议室:")
          .width("25%")
        TextInput({text:this.meetingRoomInfo.building+this.meetingRoomInfo.roomNumber})
          .enabled(false)
          .layoutWeight(1)
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("开始时间:")
          .width("25%")
        Text("选择")
          .padding(5)
          .borderRadius(10)
          .backgroundColor($r("app.color.clockin_text_blue"))
          .fontColor($r("app.color.clockin_text_white"))
          .onClick(()=>{
            DatePickerDialog.show({
              showTime: true,
              useMilitaryTime: true,
              alignment: DialogAlignment.Bottom,
              onDateAccept: (value: Date) => {
                //手动 ohpm install @hview/dayjs 安装第三方日期依赖
                this.subscribeMeetingDDDModel.meetingSubscribe.startTime = dayjs(value).format("YYYY-MM-DD HH:mm:ss")
                this.showStartTime = dayjs(value).format("YYYY-MM-DD HH:mm:ss")
              }
            })
          })
        Text(this.showStartTime)
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("结束时间:")
          .width("25%")
        Text("选择")
          .padding(5)
          .borderRadius(10)
          .backgroundColor($r("app.color.clockin_text_blue"))
          .fontColor($r("app.color.clockin_text_white"))
          .onClick(()=>{
            DatePickerDialog.show({
              showTime: true,
              useMilitaryTime: true,
              alignment: DialogAlignment.Bottom,
              onDateAccept: (value: Date) => {
                //手动 ohpm install @hview/dayjs 安装第三方日期依赖
                this.subscribeMeetingDDDModel.meetingSubscribe.endTime = dayjs(value).format("YYYY-MM-DD HH:mm:ss")
                this.showEndTime = dayjs(value).format("YYYY-MM-DD HH:mm:ss")
              }
            })
          })
        Text(this.showEndTime)
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("会议主题:")
        .width("25%")
        TextInput()
          .layoutWeight(1)
          .onChange((v)=>{
            this.subscribeMeetingDDDModel.meetingSubscribe.meetingTheme = v
          })
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("参会人数:")
        .width("25%")
        TextInput()
          .layoutWeight(1)
          .type(InputType.Number) // 调起数字键盘
          .maxLength(3) // 限制最大输入位数
          .onChange((value: string) => {
            // 实时过滤非数字字符
            this.subscribeMeetingDDDModel.meetingSubscribe.participants = parseInt(value)
          })
      }
      .width("100%")
      .height(40)
      Row({space:5}){
        Text("申请部门:")
        .width("25%")
        Select([
          { value: "教研部" },
          { value: "教务处" },
          { value: "学生工作处" },
          { value: "招生就业处" },
          { value: "财务处" },
          { value: "后勤保障处" },
          { value: "国际交流处" },
          { value: "科研处" },
          { value: "图书馆" },
          { value: "保卫处" },
          { value: "团委" },
          { value: "研究生院" },
          { value: "继续教育学院" },
          { value: "体育教学部" },
          { value: "网络信息中心" }
        ])
          .value("请选择")
          .onSelect((index:number,value:string)=>{
            if(value === "请选择"){
              return
            }
            this.subscribeMeetingDDDModel.meetingSubscribe.department = value
          })
      }
      .width("100%")
      .height(40)

      Row({space:5}){
        Text("会议类型:")
        .width("25%")
        Select([
          { value: "普通会议" },
          { value: "党委会议" },
          { value: "部门会议" }
        ])
          .value("请选择")
          .onSelect((index:number,value:string)=>{
            if(value === "请选择"){
              return
            }
            this.subscribeMeetingDDDModel.meetingSubscribe.meetingType = value
          })
      }
      .width("100%")
      .height(40)
      TextArea({ placeholder: "请输入申请的原因" })
        .width("100%")
        .height(100)
        .fontColor($r("app.color.clockin_text_gray"))
        .margin({ top: 10, bottom: 10 })
        .maxLength(50)
        .onChange((value) => {
          this.subscribeMeetingDDDModel.affair.applyReason = value
        })

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
        Text("确 定")
          .layoutWeight(1)
          .height(50)
          .borderRadius(10)
          .fontColor($r("app.color.MeetingTabList_button_font"))
          .backgroundColor($r("app.color.MeetingTabList_button_background"))
          .textAlign(TextAlign.Center)
          .onClick(()=>{
            if(this.isCanClick()){
              this.subscribeMeetingDDDModel.user = AppStorage.get(CommonConstants.APP_STORAGE_USER) as User
              this.subscribeMeetingDDDModel.meetingRoom = this.meetingRoomInfo
              //回调给父组件
              this.clickCallBack(this.subscribeMeetingDDDModel)
            }
          })
      }
      .width("80%")
    }
    .width("100%")
    .height("100%")
    .padding(20)
  }
}