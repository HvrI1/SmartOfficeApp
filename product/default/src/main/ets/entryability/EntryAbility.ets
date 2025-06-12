import { AbilityConstant, common,  UIAbility, Want } from '@kit.AbilityKit';
import { display, promptAction, window } from '@kit.ArkUI';
import { BreakpointConstants, CommonConstants, PreferenceUtil, WindowUtil}   from 'base';
import { queryUserInfoByUsernameApi } from 'auth/src/main/ets/api/index';
import { User } from 'auth/src/main/ets/pojo/index';
import { IBestInit } from "@ibestservices/ibest-ui"
import { preferences } from '@kit.ArkData';
import Logger from 'base/src/main/ets/util/Logger';
import { deviceInfo } from '@kit.BasicServicesKit';
import { HMRouterMgr } from '@hadss/hmrouter';

export default class EntryAbility extends UIAbility {
  private windowObject?: window.Window;
  private windowUtil?: WindowUtil;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.log(JSON.stringify(want))
    this.windowUtil = WindowUtil.getInstance();
  }


  onWindowStageCreate(windowStage: window.WindowStage): void {
    this.init(windowStage,this.context)
  }
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.log(JSON.stringify(want))
  }

  async init(windowStage: window.WindowStage,context:common.UIAbilityContext){
    await this.windowInit(windowStage)
    await this.auth(windowStage,context)

  }



  /*
  @function:设备屏幕信息初始化
  @description:
  * 1.AppStorage更新存储当前设备的"断点类型"-------->BreakpointConstants.CURRENT_BREAKPOINT
  * 2.AppStorage更新存储当前设备的"屏幕宽度(px)"-------->BreakpointConstants.WINDOW_WIDTH
  * 3.添加监听器"windowSizeChange"监听"屏幕宽度变化(px)"更新至AppStorage--------->BreakpointConstants.WINDOW_WIDTH
  * 4.添加监听器"windowStatusChange"监听"屏幕状态变化"并更新至AppStorage-------->BreakpointConstants.IS_SPLIT_MODE(方法内只处理了是否是分屏模式)
  * 5.判断是否需要"全屏沉浸式":此处判断除了2in1设备不需要沉浸其他的都要沉浸式
  * 6.获取当前设备的"顶部避让"和"底部避让高度"并存储到AppStorage --------->CommonConstants.AVOID_RECT_HEIGHT_TOP和CommonConstants.AVOID_RECT_HEIGHT_BOTTOM
  @params:
  @return:
  */
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


  async auth(windowStage: window.WindowStage,context:common.UIAbilityContext){
    //从首选项中拿用户的token和用户信息
    const store = AppStorage.get(CommonConstants.PREFERENCE_UTIL) as PreferenceUtil
    if(store){
      const token =await store.getPreferenceValue(CommonConstants.PREF_TOKEN) as string
      const userLocalInfo = await store.getPreferenceValue(CommonConstants.PREF_USER) as User
      AppStorage.setOrCreate(CommonConstants.APP_STORAGE_TOKEN, token)
      AppStorage.setOrCreate(CommonConstants.APP_STORAGE_USER, userLocalInfo)
      windowStage.loadContent("pages/Index",()=>{
        IBestInit(windowStage, context)
      })//跳转至登录
    }
    

  }

}










