import { preferences } from "@kit.ArkData"
import { APP_SETTING, TOKEN_KEY, USER_INFO } from "basic"
import { User } from "../pojo"


export class UserSettingClass{
  private  context:Context

  constructor(context:Context) {
    this.context=context
  }

  //获取首选项仓库
  private getStore():Promise<preferences.Preferences>{
    return preferences.getPreferences(this.context,APP_SETTING)
  }



  // //广告的数据存取
  // async setUserAd(ad:AdvertClass):Promise<void>{
  //   const store = await this.getStore()
  //   await store.put(USER_SETTING_AD,JSON.stringify(ad))
  //   await store.flush()
  // }

  // async getUserAd():Promise<AdvertClass>{
  //   const store = await this.getStore()
  //   const result =  await store.get(USER_SETTING_AD,JSON.stringify(defaultAd))
  //   return JSON.parse(result as string) as AdvertClass
  // }
  //
  //令牌信息存入
  async setUserToken(token:string):Promise<void>{
    const store = await this.getStore()
    await store.put(TOKEN_KEY,token)
    await store.flush()
  }
  //令牌信息取出
  async getUserToken():Promise<string>{
    const store = await this.getStore()
    const token =  await store.get(TOKEN_KEY,"") as string
    return token
  }

  //用户信息存入
  async setUserInfo(user:User):Promise<void>{
    const store = await this.getStore()
    await store.put(USER_INFO,user)
    await store.flush()
  }
  //用户信息取出
  async getUserInfo():Promise<User>{
    const store = await this.getStore()
    const token =  await store.get(USER_INFO,{}) as User
    return token
  }

}
