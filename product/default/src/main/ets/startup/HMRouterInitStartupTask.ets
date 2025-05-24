import { HMRouterMgr } from '@hadss/hmrouter';
import { StartupTask, common } from '@kit.AbilityKit';
import { CommonConstants } from 'basic';
import Logger from 'basic/src/main/ets/util/Logger';

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
  }

  onDependencyCompleted(dependence: string, result: Object): void {
    Logger.info(CommonConstants.LOGGER_PREFIX,`HMRouterInitStartupTask的回调，dependence:${dependence},result:${result}`)
  }
}