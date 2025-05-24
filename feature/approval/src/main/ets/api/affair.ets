import { RequestAxios,Result } from "basic"
import { MeetingSubscribeInfo, SubscribeDDDInfo } from "../pojo"
import { AffairInfo, ApprovalDto } from "../pojo/affair"


export const getAffairApi = async ()=>{
  const res:Result<AffairInfo[]> =  await RequestAxios.get(`/affair/getAffairList`)
  return res
}

export const getSubscribeApi = async (userId:number)=>{
  const res:Result<SubscribeDDDInfo> =  await RequestAxios.get(`/affair/getSubscribeList?userId=${userId}`)
  return res
}

export const queryUserMeetingSubscribeAffairInfoApi = async (userId:number)=>{
  const res:Result<AffairInfo[]> =  await RequestAxios.get(`/affair/getUserMeetingSubscribeAffair?userId=${userId}`)
  return res
}

export const selectMeetingSubscribeInfoApi = async (affairId:number) =>{
  const res:Result<MeetingSubscribeInfo> =  await RequestAxios.get(`/affair/getMeetingInfoByAffairId?affairId=${affairId}`)
  return res
}

export const execApprovalApi =async (approvalDto:ApprovalDto)=>{
  const res:Result<number> =  await RequestAxios.put<Result<number>>(`/affair/execApproval`,approvalDto)
  return res
}