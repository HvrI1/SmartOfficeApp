import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { promptAction, window } from '@kit.ArkUI';
import { TOKEN_KEY, USER_INFO } from 'basic';
import { queryUserInfoByUsernameApi } from '../api';
import { User } from '../pojo';
import { UserSettingClass } from '../util/preferences';


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {

  }

  onDestroy(): void {

  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    //验证是否自动登录
    //注意这里使用上下文this.context
    checkAutoLogin(windowStage,this.context)
  }

  onWindowStageDestroy(): void {

  }

  onForeground(): void {

  }

  onBackground(): void {

  }
}

async function checkAutoLogin(windowStage: window.WindowStage,context:Context){
  //从首选项中拿用户的token和用户信息
  const store =  new UserSettingClass(context)
  const token =  await store.getUserToken()
  const userLocalInfo =  await store.getUserInfo()
  if(!token || !userLocalInfo){//如果本地token和用户信息有一个为空
    promptAction.showToast({message:"用户信息已过期,请重新登录"})
    windowStage.loadContent("pages/Login/Login")//跳转至广告
    return
  }
  //将token存入AppStorage
  AppStorage.setOrCreate(TOKEN_KEY,token)

  windowStage.loadContent("pages/MeetingSubscribe/MeetingSubscribe")//TODO:

  //做一次拿数据信息的请求
  //TODO:应该设置请求最长时间，加载不到不能一直卡在这里
  const res = await queryUserInfoByUsernameApi(userLocalInfo.username)
  const userRemoteInfo = res.data as User
  if(res.code===200){//只要能请求到数据，证明token没有过期
    //更新用户信息
    AppStorage.setOrCreate(USER_INFO,userRemoteInfo)
    //异步：存值
    store.setUserInfo(userRemoteInfo)
    //跳转首页
    promptAction.showToast({message:"用户已登录"})
    if(userRemoteInfo.isVip === "普通用户"){
      windowStage.loadContent("pages/Advert/Advert")//跳转至广告
    }else {
      windowStage.loadContent("pages/Index/Index")//跳转至登录
    }
    return
  }else {//请求不到数据，证明token过期
    promptAction.showToast({message:"用户信息已过期,请重新登录"})
    windowStage.loadContent("pages/Login/Login")//跳转至广告
    return
  }
}