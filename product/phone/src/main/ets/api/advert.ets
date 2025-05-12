import { RequestAxios, Result } from "basic"
import { AdvertInfo, getAdvertDto } from "../pojo"

export const getAdvertByPosition = async (getAdvertDto:getAdvertDto)=>{
  const res:Result<AdvertInfo[]> =  await RequestAxios.post(`/advert/getAdvert`,getAdvertDto)
  return res
}