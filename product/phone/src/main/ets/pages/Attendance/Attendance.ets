import dayjs from '@hview/dayjs'
import { BacKNav } from 'basic'
import {  CalendarAttendance } from './Calendar'

@Entry
@Component
struct Attendance {

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