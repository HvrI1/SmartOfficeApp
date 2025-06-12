import { HMRouterMgr } from '@hadss/hmrouter';
import { StartupTask, common } from '@kit.AbilityKit';
import { CommonConstants } from 'base';
import Logger from 'base/src/main/ets/util/Logger';

@Sendable
export default class HMRouterInitStartupTask extends StartupTask {
  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    HMRouterMgr.init({
      context: context
    })
    HMRouterMgr.openLog('DEBUG')
    Logger.info(CommonConstants.LOGGER_PREFIX,`HMRouterMgr启动成功`)
  }

  onDependencyCompleted(dependence: string, result: Object): void {
    Logger.info(CommonConstants.LOGGER_PREFIX,`HMRouterInitStartupTask的回调，dependence:${dependence},result:${result}`)
  }
}