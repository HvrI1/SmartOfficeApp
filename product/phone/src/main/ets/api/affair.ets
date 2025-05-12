import { RequestAxios,Result } from "basic"
import { SubscribeDDDInfo } from "../pojo"
import { AffairInfo } from "../pojo/affair"


export const getAffairApi = async ()=>{
  const res:Result<AffairInfo[]> =  await RequestAxios.get(`/affair/getAffairList`)
  return res
}

export const getSubscribeApi = async (userId:number)=>{
  const res:Result<SubscribeDDDInfo> =  await RequestAxios.get(`/affair/getSubscribeList?userId=${userId}`)
  return res
}