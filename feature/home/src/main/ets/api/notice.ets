import { RequestAxios,Result } from "base"
import { NoticeInfo } from "../pojo"

export const getAllNoticeApi =async ()=>{
  const  res:Result<NoticeInfo[]> =  await RequestAxios.get<Result<NoticeInfo[]>>("/notice/getAllNotice")
  return res
}

export const getUserNoticeApi =async (userId:number)=>{
  const  res:Result<NoticeInfo[]> =  await RequestAxios.get<Result<NoticeInfo[]>>(`/notice/queryNoticeByPublisherId?publisherId=${userId}`)
  return res
}