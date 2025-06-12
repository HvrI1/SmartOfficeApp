import dayjs from "@hview/dayjs"
import { CommonConstants, formatDate } from "base"
import { queryUserAllAttendanceInfoApi } from "../../api"
import { User } from "../../pojo"
import { AttendanceInfo } from "../../pojo"
import { promptAction } from "@kit.ArkUI"

//类型约束：当前天
class DateItem{
  year:number = 0
  month:number = 0
  date:number = 0
  isSelect:boolean =false
}

@Component
export struct CalendarAttendance{

  //状态：父传子单向 当前日期
  @Watch("updateDays")
  @Prop currentDate:string

  //当前用户的信息
  @StorageProp(CommonConstants.APP_STORAGE_USER)
  userInfo:User = {} as User

  //状态：当前用户的所有打卡记录
  @State userAllAttendanceList:AttendanceInfo[] = []

  updateDays(){
    this.days = this.getDays(this.currentDate)
  }

  //状态：当前月的所有天的对象数组
  @State days:DateItem[] = []

  //状态：当前选中的下标
  @State currentIndex:number = -1

  //状态：选中天的打卡详情AttendanceInfo
  @State currentAttendance:AttendanceInfo[]=[]

  //映射方法:当月份切换的时候，要通知父组件
  //TODO:这个方法适配当前案例,自己按需求定义回调
  onChangeMonth=(currentDate:string)=>{}

  //属性：当前天的DateItem
  currentDateItem:DateItem = {} as DateItem

  //内部属性
  private weeks:string[] = ["周日","周一","周二","周三","周四","周五","周六"]
  private format:string = "YYYY-MM-DD"


  //组件：考勤信息单项
  @Builder
  attendanceItem(item:AttendanceInfo,index:number){
    Column({space:15}){
      //顶部信息区域
      Row({space:10}){
        Text(item.attendanceSection?.slice(0,1))
          .borderRadius(50)
          .backgroundColor($r("app.color.clockin_text_blue"))
          .fontSize($r("app.float.clockin_text_little"))
          .width(25)
          .aspectRatio(1)
          .textAlign(TextAlign.Center)
          .fontColor($r("app.color.clockin_text_white"))
        Text(item.attendanceSection+"打卡")
          .fontSize($r("app.float.clockin_text_little"))
        Text(item.state)
          .fontSize($r("app.float.clockin_text_little"))
          .padding(5)
          .borderRadius(10)
          .fontColor($r("app.color.clockin_text_white"))
          .backgroundColor(item.state==="正常"?$r("app.color.clockin_text_green"):$r("app.color.clockin_text_red"))
      }
      .width("100%")
      //打卡时间信息
      Row({space:5}){
        SymbolGlyph($r("sys.symbol.clock"))
          .fontSize($r("app.float.clockin_text_glyph"))
          .fontColor([$r("app.color.clockin_text_gray")])
        Text(item.attendanceDate)
          .fontSize($r("app.float.clockin_text_little"))
          .width("90%")
      }
      .width("100%")
      //地点信息
      Row({space:5}){
        SymbolGlyph($r("sys.symbol.local_fill"))
          .fontSize($r("app.float.clockin_text_glyph"))
          .fontColor([$r("app.color.clockin_text_gray")])
        Text(item.location)
          .fontSize($r("app.float.clockin_text_little"))
          .width("90%")
      }
      .width("100%")
    }
    .width("90%")
    .borderRadius(10)
    .backgroundColor(item.state==="正常"?$r("app.color.Calendar_item_card_background"):$r("app.color.Calendar_item_card_background_exception"))
    .padding(10)

  }


  //获取日历
  getDays(originDate:string){
    //日历所有天数数组
    const days:DateItem[] = []
    //元素个数上限(一行7个，最多6行)
    const len = 42
    //将originDate从字符串转为dayjs.Dayjs这个对象
    const date = dayjs(originDate)
    //系统当前时间的对象
    const  nowDate = new Date()
    //获取传入日期当月有多少天
    const currentDays = date.daysInMonth()
    for (let i = 1; i <= currentDays; i++) {
      days.push({
        year:date.year(),
        month:date.month()+1,
        date:i,
        isSelect:date.year()===nowDate.getFullYear()
          && date.month() === nowDate.getMonth()
          && i === nowDate.getDate()
      } as DateItem)
    }

    //上个月
    const preMonth = date.date(0)//得到上个月
    const preMonthLastDate = preMonth.date() // 上个月的最后一天
    const preDays = preMonth.day() //上个月最后一天是星期几(0-6)
    //如果等于6，那就不需要这一行了，所以小于6才需要管
    if(preDays<6){
      //循环的是星期
      for (let i = 0; i <= preDays; i++) {
        //倒过来，往数组中插
        days.unshift({
          year:preMonth.year(),
          month:preMonth.month()+1,
          date:preMonthLastDate-i,
          isSelect:false
        } as DateItem)

      }
    }

    //下个月
    const nextMonth = date.date(currentDays+1)//得到上个月
    const end =days.length//数组元素个数截至
    //FIXME:增加了循环前的判断，避免显示多一行，如果就想多一行，就把判断去掉，直接i <= len-end即可
    const cycleNum=(len-end>=7)?len-end-7:len-end
      for (let i = 1; i <= cycleNum; i++) {
        days.push({
          year:nextMonth.year(),
          month:nextMonth.month()+1,
          date:i,
          isSelect:false
        } as DateItem)
      }

    return days
  }

  //方法：调用接口获取当前用户的所有打卡记录
  async queryUserAllAttendance(){
    if(this.userInfo.id){
      const res = await queryUserAllAttendanceInfoApi(this.userInfo.id)
      if(res.code === 200){
        this.userAllAttendanceList = res.data as AttendanceInfo[]
      }else {
        promptAction.showToast({message:res.message})
      }
    }

  }


  //判断item是否是当前月份
  isTheMonth(item:DateItem){
    return dayjs(this.currentDate).year() === item.year && dayjs(this.currentDate).month()+1 === item.month
  }

  //传入item，判断是否显示考勤图标
  isShowAttendanceIcon(dateItem:DateItem){
    const itemDate = formatDate(new Date(dateItem.year,dateItem.month-1,dateItem.date),true,false)
    const currentDayList:AttendanceInfo[] = []
    this.userAllAttendanceList.forEach((attendanceInfo:AttendanceInfo,index:number)=>{
    //先过滤处当天的记录有几条，最少0条，最多2条
      const attendanceInfoDate = formatDate(attendanceInfo.attendanceDate,true,false)
      if(attendanceInfoDate==itemDate){
        currentDayList.push(attendanceInfo)
      }
    })
    //如果没有记录直接返回
    if(!currentDayList.length){
      return false
    }
    return true
  }

  //传入item，判断是否异常
  isAttendanceNormal(dateItem:DateItem){
    let result:boolean = true
    const itemDate = formatDate(new Date(dateItem.year,dateItem.month-1,dateItem.date),true,false)
    const currentDayList:AttendanceInfo[] = []
    this.userAllAttendanceList.forEach((attendanceInfo:AttendanceInfo,index:number)=>{
      //先过滤处当天的记录有几条，最少0条，最多2条
      const attendanceInfoDate = formatDate(attendanceInfo.attendanceDate,true,false)
      if(attendanceInfoDate==itemDate){
        currentDayList.push(attendanceInfo)
      }
    })
    //上面方法判断过是否为空，这里肯定有长度的
    if(currentDayList.length===1){
      return false
    }
    //有记录就过滤打卡状态
    currentDayList.forEach((attendanceInfo:AttendanceInfo,index:number)=>{
      if(attendanceInfo.state === "异常"){
        result = false
      }
    })
    return result
  }


  //获取当前选中天的打卡详情
  getCurrentAttendanceList(dateItem:DateItem){
    const itemDate = formatDate(new Date(dateItem.year,dateItem.month-1,dateItem.date),true,false)
    const currentDayList:AttendanceInfo[] = []
    this.userAllAttendanceList.forEach((attendanceInfo:AttendanceInfo,index:number)=>{
      //先过滤处当天的记录有几条，最少0条，最多2条
      const attendanceInfoDate = formatDate(attendanceInfo.attendanceDate,true,false)
      if(attendanceInfoDate==itemDate){
        currentDayList.push(attendanceInfo)
      }
    })
    this.currentAttendance = currentDayList
  }
  //默认加载当天的明细
  loadCurrentAttendance(){
    this.days.forEach((item:DateItem,index:number)=>{
        if(item.isSelect){
          this.currentDateItem = item
        }
    })

    this.getCurrentAttendanceList(this.currentDateItem)
  }



  //生命周期
  aboutToAppear(){
    //获取当前年月的日期(包括前后月)
    this.days = this.getDays(this.currentDate)
    //获取当前用户的所有打卡记录
    this.queryUserAllAttendance().then(()=>{
      //默认加载当天的明细
      this.loadCurrentAttendance()
    })

  }

  build() {
    Column(){
      //功能标签栏
      Row(){
        //TODO:左右箭头标签自行替换
        Image($r("app.media.ic_date_left"))
          .width(40)
          .aspectRatio(1)
          .rotate({angle:180})//TODO:旋转自行决定要不要
          .onClick(()=>{
            //更新一下当前日期
            this.currentDate = dayjs(this.currentDate).subtract(1,"month").format(this.format)
            //更新显示
            this.onChangeMonth && this.onChangeMonth(this.currentDate)
          })
        //当前
        Text(dayjs(this.currentDate).format("YYYY年MM月"))
          .fontSize(18)
          .margin({left:20,right:20})
          .width(150)
          .textAlign(TextAlign.Center)


        //TODO:左右箭头标签自行替换
        Image($r("app.media.ic_date_right"))
          .width(40)
          .aspectRatio(1)
          .onClick(()=>{
            //更新一下当前日期
            this.currentDate = dayjs(this.currentDate).add(1,"month").format(this.format)
            //更新显示
            this.onChangeMonth && this.onChangeMonth(this.currentDate)
          })

      }
      .padding(15)
      //月历
      //一行七列
      GridRow({columns:7}){
        //栏目
        ForEach(this.weeks,(item:string,index:number)=>{
          GridCol(){
            Column(){
              Text(item).fontColor($r("app.color.Calendar_text_primary"))//TODO:栏目字体颜色自行替换
            }
            .height(50)
          }
        })
        //日历
        ForEach(this.days,(item:DateItem,index:number)=>{
          GridCol(){
            Column({space:5}){
              Text(item.date.toString())
                .width(30)
                .aspectRatio(1)
                .textAlign(TextAlign.Center)
                .borderRadius(10)
                .fontColor(item.isSelect || this.currentIndex === index?$r("app.color.Calendar_text_white") :
                //第二套三目运算
                  this.isTheMonth(item)? $r("app.color.Calendar_text_primary"):$r("app.color.Calendar_text_gray")
                )//TODO:日历字体颜色自行替换
                .backgroundColor(item.isSelect?$r("app.color.Calendar_text_red"):this.currentIndex === index?$r("app.color.clockin_text_blue"):$r("app.color.Calendar_text_white"))
                .fontWeight(item.isSelect?FontWeight.Bold:FontWeight.Normal)
              if(this.isTheMonth(item) && this.isShowAttendanceIcon(item)){
                Text("")
                  .width(7)
                  .aspectRatio(1)
                  .borderRadius(50)
                  .backgroundColor(this.isAttendanceNormal(item)?$r("app.color.Calendar_attendance_normal"):$r("app.color.Calendar_attendance_exception"))
              }else {
                Text("")
                  .width(7)
                  .aspectRatio(1)
              }
            }
            .onClick(()=>{
              //改变下标
              this.currentIndex = index
              //点击对应日期显示详情
              this.getCurrentAttendanceList(item)
            })
          }

        })
      }
      .padding(15)
      .border({width:{top:1},color:$r("app.color.Calendar_text_gray")})//TODO:分隔线颜色自行替换


      Column({space:15}){
        if(this.currentAttendance.length){
          ForEach(this.currentAttendance,(item:AttendanceInfo,index:number)=>{
            this.attendanceItem(item,index)
          })
        }else {
          Text("------当前暂无打卡数据数据------")
            .width("100%")
            .textAlign(TextAlign.Center)
            .margin({top:50})
            .fontColor($r("app.color.Calendar_text_gray"))
        }
      }
      .width("100%")
      .padding(10)


    }
    .width("100%")
    .backgroundColor($r("app.color.Calendar_background"))
  }
}