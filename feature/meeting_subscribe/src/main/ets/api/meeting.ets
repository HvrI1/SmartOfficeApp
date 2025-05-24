import { RequestAxios,Result } from "basic"
import { MeetingRoomInfo, MeetingSubscribeInfo, SubscribeMeetingDDDInfo } from "../pojo"

export const queryAllMeetingRoomApi =async ()=>{
  const res:Result<MeetingRoomInfo[]> =  await RequestAxios.get<Result<MeetingRoomInfo[]>>(`/meeting/getAllMeetingRoom`)
  return res
}

export const queryAllMeetingSubscribeInfoApi = async (userId:number)=>{
  const res:Result<MeetingSubscribeInfo[]> =  await RequestAxios.get<Result<MeetingSubscribeInfo[]>>(`/meeting/getAllMeetingSubscribeRoom?userId=${userId}`)
  return res
}

export const subscribeMeetingApi = async (subscribeMeetingDDD:SubscribeMeetingDDDInfo) =>{
  const res:Result<SubscribeMeetingDDDInfo> =  await RequestAxios.post<Result<SubscribeMeetingDDDInfo>>(`/meeting/subscribeMeeting`,subscribeMeetingDDD)
  return res
}

export const selectMeetingRoomInfoApi = async  (roomId:number)=>{
  const res:Result<MeetingRoomInfo> =  await RequestAxios.get<Result<MeetingRoomInfo>>(`/meeting/getMeetingRoomByRoomId?roomId=${roomId}`)
  return res
}