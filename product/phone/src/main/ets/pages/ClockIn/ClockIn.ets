import dayjs from '@hview/dayjs'
import { BacKNav, USER_INFO } from 'basic'
import { insertAttendanceApi, queryUserAttendanceInfoApi } from '../../api'
import { AttendanceInfo, AttendanceModel, User, UserModel } from '../../pojo'
import { ClockInCard } from './ClockInCard'
import { promptAction } from '@kit.ArkUI'

//打卡页面
@Entry
@Component
struct ClockIn {

  //从AppStorage中取出用户信息
  @StorageProp(USER_INFO)
  userInfo:User = new UserModel({} as User)

  //状态：上午打卡信息，因为位置信息返回要更新位置的ui
  @State morningAttendanceInfo:AttendanceInfo = new AttendanceModel({} as AttendanceInfo)

  //状态：下午打卡信息，因为位置信息返回要更新位置的ui
  @State afternoonAttendanceInfo:AttendanceInfo = new AttendanceModel({} as AttendanceInfo)

  //状态：子组件打卡按钮显示是上午还是下午 true 上午，false 下午
  @State isChange:boolean = true

  //回调方法：子组件中的回调方法，插入打卡信息
  clockIn = async (location:string)=>{

    if(location === ""){
      promptAction.showToast({message:"必须先获取位置才可进行打卡"})
      return
    }
    if(this.afternoonAttendanceInfo.attendanceDate!=undefined){
      promptAction.showToast({message:"下班打卡已完成，不可继续打卡"})
      return
    }
    //组合信息,在请求未成功返回结果时，不使用上面的对象
    const clickModel:AttendanceInfo = new AttendanceModel({
      userId:this.userInfo.id,
      attendanceDate:dayjs(new Date()).format("YYYY-MM-DD HH:mm:ss"),
      location:location
    } as AttendanceInfo)
    //发送打卡请求
    const res  = await insertAttendanceApi(clickModel);
    //判断打卡是否成功
    if(res.code === 200){
      //成功
      if(res.data?.attendanceSection === "上午"){
        this.morningAttendanceInfo = res.data as AttendanceInfo
        this.isChange=false
      }else if(res.data?.attendanceSection === "下午"){
        this.afternoonAttendanceInfo = res.data as AttendanceInfo
      }
    }else {
      //失败
      promptAction.showToast({message:res.message})
    }
  }




  //刷新操作:根据当前用户查询当天的打卡信息
  async  refresh(){
    //调用接口拿到数据
    const res =  await queryUserAttendanceInfoApi(this.userInfo.id as number)
    //判断是否调用成功
    if(res.code===200){
      //根据数组长度判断按扭文字状态
      if(res.data?.length === 2||res.data?.length === 1){
        this.isChange = false
      }
      //遍历数组，给数据源赋值
      res.data?.forEach((item:AttendanceInfo) => {
        if(item.attendanceSection==="上午"){
          this.morningAttendanceInfo = item
        }else if(item.attendanceSection==="下午"){
          this.afternoonAttendanceInfo = item
        }
      });

    }else {
      promptAction.showToast({message:res.message})
    }
  }


  //生命周期
  aboutToAppear(): void {
    //每次进来刷新打卡信息。
    this.refresh()

  }

  //声明周期:页面销毁时需要清除对象，防止过了今天还在用昨天的对象
  aboutToDisappear(): void {
    this.morningAttendanceInfo = {} as AttendanceInfo
    this.afternoonAttendanceInfo = {} as AttendanceInfo
    this.isChange=true
  }

  build() {
    Column(){
      //头部导航
      BacKNav({
        title:"考勤打卡",
        isShowBack:true,
        isShowSearch:false
      })
        .backgroundColor($r("app.color.page_nav_background_white"))
      //显示用户基本信息
      Row(){
        Column({space:10}){
          Text(this.userInfo.nick)
            .fontSize($r("app.float.clockin_text_normal"))
            .width("100%")
          Text(this.userInfo.lastLoginIp+"-专任教师-在岗")
            .fontSize($r("app.float.clockin_text_little"))
            .fontColor($r("app.color.clockin_text_gray"))
            .width("100%")
        }
        .layoutWeight(1)
        Row(){
          Text("日期："+dayjs(new Date()).format("YYYY-MM-DD"))
            .fontColor($r("app.color.clockin_text_blue"))
            .fontSize($r("app.float.clockin_text_little"))
            .maxLines(1)
        }
      }
      .width('100%')
      .height(50)
      .alignItems(VerticalAlign.Top)
      .backgroundColor($r("app.color.page_nav_background_white"))
      .padding({left:10,right:10})


      //打卡区域
      if(this.morningAttendanceInfo.attendanceDate!==undefined || (this.morningAttendanceInfo.attendanceDate===undefined && this.afternoonAttendanceInfo.attendanceDate !=undefined )){
        //显示上午已打卡
        Column({space:10}){
          //顶部信息
          Row({space:5}){
            Text(this.morningAttendanceInfo.attendanceSection===undefined?"上":this.morningAttendanceInfo.attendanceSection?.slice(0,1))
              .borderRadius(50)
              .backgroundColor($r("app.color.clockin_text_blue"))
              .fontSize($r("app.float.clockin_text_little"))
              .width(25)
              .aspectRatio(1)
              .textAlign(TextAlign.Center)
              .fontColor($r("app.color.clockin_text_white"))

            Text(this.morningAttendanceInfo.attendanceSection===undefined?"上午打卡": this.morningAttendanceInfo.attendanceSection+"打卡")
              .fontSize($r("app.float.clockin_text_little"))
            Text(this.morningAttendanceInfo.attendanceDate===undefined && this.afternoonAttendanceInfo.attendanceDate !=undefined?"旷班":this.morningAttendanceInfo.state)
              .fontSize($r("app.float.clockin_text_little"))
              .padding(5)
              .borderRadius(10)
              .fontColor($r("app.color.clockin_text_white"))
              .backgroundColor(this.morningAttendanceInfo.state==="正常"?$r("app.color.clockin_text_green"):$r("app.color.clockin_text_red"))
          }
          .width("100%")
          //打卡时间信息
          Row({space:5}){
            SymbolGlyph($r("sys.symbol.clock"))
              .fontSize($r("app.float.clockin_text_glyph"))
              .fontColor([$r("app.color.clockin_text_gray")])
            Text(this.morningAttendanceInfo.attendanceDate===undefined && this.afternoonAttendanceInfo.attendanceDate !=undefined?"无打卡记录":`打卡时间:`+this.morningAttendanceInfo.attendanceDate)
              .fontSize($r("app.float.clockin_text_little"))
              .width("90%")
          }
          .width("100%")
          //地点信息
          Row({space:5}){
            SymbolGlyph($r("sys.symbol.local_fill"))
              .fontSize($r("app.float.clockin_text_glyph"))
              .fontColor([$r("app.color.clockin_text_gray")])
            Text(this.morningAttendanceInfo.attendanceDate===undefined && this.afternoonAttendanceInfo.attendanceDate !=undefined?"未知地址":`打卡位置:`+this.morningAttendanceInfo.location)
              .fontSize($r("app.float.clockin_text_little"))
              .width("90%")
          }
          .width("100%")
        }
        .width("90%")
        .padding(20)
        .backgroundColor($r("app.color.page_nav_background_white"))
        .borderRadius(10)
        .margin({top:15})
      }
      if(this.afternoonAttendanceInfo.attendanceDate!==undefined){
        //显示下午已打卡
        Column({space:10}){
          //顶部信息
          Row({space:5}){
            Text(this.afternoonAttendanceInfo.attendanceSection?.slice(0,1))
              .borderRadius(50)
              .backgroundColor($r("app.color.clockin_text_blue"))
              .fontSize($r("app.float.clockin_text_little"))
              .width(25)
              .aspectRatio(1)
              .textAlign(TextAlign.Center)
              .fontColor($r("app.color.clockin_text_white"))
            Text(this.afternoonAttendanceInfo.attendanceSection+"打卡")
              .fontSize($r("app.float.clockin_text_little"))
            Text(this.afternoonAttendanceInfo.state)
              .fontSize($r("app.float.clockin_text_little"))
              .padding(5)
              .borderRadius(10)
              .fontColor($r("app.color.clockin_text_white"))
              .backgroundColor(this.afternoonAttendanceInfo.state==="正常"?$r("app.color.clockin_text_green"):$r("app.color.clockin_text_red"))
          }
          .width("100%")
          //打卡时间信息
          Row({space:5}){
            SymbolGlyph($r("sys.symbol.clock"))
              .fontSize($r("app.float.clockin_text_glyph"))
              .fontColor([$r("app.color.clockin_text_gray")])
            Text(`打卡时间:`+this.afternoonAttendanceInfo.attendanceDate)
              .fontSize($r("app.float.clockin_text_little"))
              .width("90%")
          }
          .width("100%")
          //地点信息
          Row({space:5}){
            SymbolGlyph($r("sys.symbol.local_fill"))
              .fontSize($r("app.float.clockin_text_glyph"))
              .fontColor([$r("app.color.clockin_text_gray")])
            Text(`打卡位置:`+this.afternoonAttendanceInfo.location)
              .fontSize($r("app.float.clockin_text_little"))
              .width("90%")
          }
          .width("100%")
        }
        .width("90%")
        .padding(20)
        .backgroundColor($r("app.color.page_nav_background_white"))
        .borderRadius(10)
        .margin({top:15})

      }
      ClockInCard({
        isChange:this.isChange,
        clickCallBack:this.clockIn
      })
        .margin({top:15})



    }
    .height('100%')
    .width('100%')
    .backgroundColor($r("app.color.page_background_normal"))
  }
}