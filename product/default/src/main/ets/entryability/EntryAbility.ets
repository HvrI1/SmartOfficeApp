import { AbilityConstant, common,  UIAbility, Want } from '@kit.AbilityKit';
import { promptAction, window } from '@kit.ArkUI';
import { BreakpointConstants, CommonConstants, PreferenceUtil, WindowUtil}   from 'basic';
import { queryUserInfoByUsernameApi } from 'auth/src/main/ets/api/index';
import { User } from 'auth/src/main/ets/pojo/index';
import { IBestInit } from "@ibestservices/ibest-ui"
import { preferences } from '@kit.ArkData';
import Logger from 'basic/src/main/ets/util/Logger';
import { deviceInfo } from '@kit.BasicServicesKit';

export default class EntryAbility extends UIAbility {
  private windowObject?: window.Window;
  private windowUtil?: WindowUtil;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.windowUtil = WindowUtil.getInstance();
  }


  onWindowStageCreate(windowStage: window.WindowStage): void {
    this.init(windowStage,this.context)
  }

  async init(windowStage: window.WindowStage,context:common.UIAbilityContext){
    await this.windowInit(windowStage)
    await this.checkAuthLogin(windowStage,context)
  }


  async windowInit(windowStage: window.WindowStage){
    windowStage.getMainWindow().then((data: window.Window) => {
      this.windowObject = data;
      this.windowUtil?.updateBreakpoint(this.windowObject.getWindowProperties().windowRect.width);
      AppStorage.setOrCreate(BreakpointConstants.WINDOW_WIDTH, this.windowObject.getWindowProperties().windowRect.width);
      this.windowObject.on("windowSizeChange", (windowSize: window.Size) => {
        this.windowUtil?.updateBreakpoint(windowSize.width);
        AppStorage.setOrCreate(BreakpointConstants.WINDOW_WIDTH, windowSize.width);
      });
      this.windowObject.on("windowStatusChange", (windowStatusType: window.WindowStatusType) => {
        this.windowUtil?.updateWindowStatusType(windowStatusType);
      }
      );
    })
    if (this.windowUtil !== undefined) {
      this.windowUtil.setWindowStage(windowStage);
      this.windowUtil.setMainWindow().then(()=>{
        if (deviceInfo.deviceType !== CommonConstants.DEVICE_TYPES[2]) {
          this.windowUtil?.setFullScreen();
        }
        this.windowUtil?.setAvoidRectHeight();
      })
    }
  }

  async  checkAuthLogin(windowStage: window.WindowStage,context:common.UIAbilityContext){
    try {
      //从首选项中拿用户的token和用户信息
      await PreferenceUtil.getInstance()?.loadPreference(context)
      const store= AppStorage.get<PreferenceUtil>(CommonConstants.PREFERENCE_UTIL)
      const token = await store?.getPreferenceValue(CommonConstants.PREF_TOKEN) as string
      const userLocalInfo = await store?.getPreferenceValue(CommonConstants.PREF_USER) as User
      if(!token || !userLocalInfo){//如果本地token和用户信息有一个为空
        promptAction.showToast({message:"用户信息已过期,请重新登录"})
        windowStage.loadContent("pages/Index",()=>{
          IBestInit(windowStage, context)
        })//跳转至登录
        return
      }
      //将token存入AppStorage
      AppStorage.setOrCreate(CommonConstants.APP_STORAGE_TOKEN,token)
      //做一次拿数据信息的请求
      //TODO:应该设置请求最长时间，加载不到不能一直卡在这里
      const res = await queryUserInfoByUsernameApi(userLocalInfo.username)
      const userRemoteInfo = res.data as User
      if(res.code===200){//只要能请求到数据，证明token没有过期
        //更新用户信息
        AppStorage.setOrCreate(CommonConstants.APP_STORAGE_USER,userRemoteInfo)
        //异步：存值
        store?.putPreference(CommonConstants.PREF_USER,userRemoteInfo)
        //跳转首页
        promptAction.showToast({message:"用户已登录"})
        if(userRemoteInfo.isVip === "普通用户"){
          windowStage.loadContent("pages/Index",()=>{
            IBestInit(windowStage, context)
          })//跳转至广告
        }else {
          windowStage.loadContent("pages/Index",()=>{
            IBestInit(windowStage, context)
          })//跳转至登录
        }
        return
      }else {//请求不到数据，证明token过期
        promptAction.showToast({message:"用户信息已过期,请重新登录"})
        windowStage.loadContent("pages/Index",()=>{
          IBestInit(windowStage, context)
        })//跳转至广告
        return
      }
    }catch (error) {
      Logger.error(CommonConstants.LOGGER_PREFIX,`用户认证检查失败,code:${error.code},message:${error.message}`)
    }
  }


}










