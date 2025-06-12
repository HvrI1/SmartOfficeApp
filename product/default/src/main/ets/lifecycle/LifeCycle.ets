import { HMLifecycle, HMLifecycleContext, IHMLifecycle } from "@hadss/hmrouter";
import { CommonConstants } from "base";
import Logger from "base/src/main/ets/util/Logger";

@HMLifecycle({ lifecycleName: 'phoneLifecycle' })
export class PageDurationLifecycle implements IHMLifecycle {
  private time: number = 0;

  onShown(ctx: HMLifecycleContext): void {
    this.time = new Date().getTime();
    Logger.info(CommonConstants.LOGGER_PREFIX,`onShown ${ctx.navContext?.pathInfo.name} stay ${this.time}`);
  }

  onHidden(ctx: HMLifecycleContext): void {
    const duration = new Date().getTime() - this.time;
    Logger.info(CommonConstants.LOGGER_PREFIX,`onHidden ${ctx.navContext?.pathInfo.name} stay ${duration}`);
  }
  onPrepare?(ctx: HMLifecycleContext): void{
    Logger.info(CommonConstants.LOGGER_PREFIX,`onPrepare:${ctx.navContext?.pathInfo.name}`)
  }
  onAppear?(ctx: HMLifecycleContext): void{
    Logger.info(CommonConstants.LOGGER_PREFIX,`onAppear:${ctx.navContext?.pathInfo.name}`)
  }
  onDisAppear?(ctx: HMLifecycleContext): void{
    Logger.info(CommonConstants.LOGGER_PREFIX,`onDisAppear:${ctx.navContext?.pathInfo.name}`)
  }
  onWillAppear?(ctx: HMLifecycleContext): void{
    Logger.info(CommonConstants.LOGGER_PREFIX,`onWillAppear:${ctx.navContext?.pathInfo.name}`)
  }
  onWillDisappear?(ctx: HMLifecycleContext): void{
    Logger.info(CommonConstants.LOGGER_PREFIX,`onWillDisappear:${ctx.navContext?.pathInfo.name}`)
  }
  onWillShow?(ctx: HMLifecycleContext): void{
    Logger.info(CommonConstants.LOGGER_PREFIX,`onWillShow:${ctx.navContext?.pathInfo.name}`)
  }
  onWillHide?(ctx: HMLifecycleContext): void{
    Logger.info(CommonConstants.LOGGER_PREFIX,`onWillHide:${ctx.navContext?.pathInfo.name}`)
  }
  onReady?(ctx: HMLifecycleContext): void{
    Logger.info(CommonConstants.LOGGER_PREFIX,`onReady:${ctx.navContext?.pathInfo.name}`)
  }
  onBackPressed?(ctx: HMLifecycleContext): boolean{
    Logger.info(CommonConstants.LOGGER_PREFIX,`onBackPressed:${ctx.navContext?.pathInfo.name}`)
    return true
  }
}