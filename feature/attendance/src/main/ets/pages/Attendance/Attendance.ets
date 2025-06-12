import { HMRouter } from '@hadss/hmrouter'
import dayjs from '@hview/dayjs'
import { BacKNav } from 'base'
import {  CalendarAttendance } from './Calendar'

@HMRouter({pageUrl:"AttendanceComp"})
@Component
export  struct Attendance {

  build() {
    Column(){
      //顶部导航栏
      BacKNav({
        title:"我的考勤",
        isShowBack:true
      })
      //万年历显示考勤
      CalendarAttendance({
        currentDate:dayjs().format("YYYY-MM-DD"),
        onChangeMonth:(currentDate:String)=>{
           //TODO:点击更新月份拿到新日期的回调
        }
      })

    }
    .height('100%')
    .width('100%')
  }
}