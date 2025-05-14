import { RequestAxios ,Result} from "basic"
import { AttendanceInfo } from "../pojo"

//接口定义：插入一条打卡记录
export const insertAttendanceApi = async (attendance:AttendanceInfo)=>{
  const res:Result<AttendanceInfo> =  await RequestAxios.post<Result<AttendanceInfo>>(`/attendance/insertAttendance`,attendance)
  return res
}

//接口定义：刷新操作，根据用户id查询当天的打卡记录
export const queryUserAttendanceInfoApi = async (userId:number)=>{
  const res:Result<AttendanceInfo[]> =  await RequestAxios.get<Result<AttendanceInfo[]>>(`/attendance/queryUserAttendanceInfoByUserId?userId=${userId}`)
  return res
}



  //接口定义：刷新操作，根据用户id查询当天的打卡记录
export const queryUserAllAttendanceInfoApi = async (userId:number)=>{
  const res:Result<AttendanceInfo[]> =  await RequestAxios.get<Result<AttendanceInfo[]>>(`/attendance/queryUserAllAttendanceInfoByUserId?userId=${userId}`)
  return res
}