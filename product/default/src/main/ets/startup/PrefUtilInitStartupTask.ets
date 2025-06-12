import { StartupTask, common } from '@kit.AbilityKit';
import { CommonConstants, PreferenceUtil } from 'base';
import Logger from 'base/src/main/ets/util/Logger';

@Sendable
export default class PrefUtilInitStartupTask extends StartupTask {

  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    const prefUtil:PreferenceUtil = PreferenceUtil.getInstance() as PreferenceUtil;
    await prefUtil.loadPreference(context);
    Logger.info(CommonConstants.LOGGER_PREFIX,`prefUtil启动成功`)
  }

  onDependencyCompleted(dependence: string, result: Object): void {
    Logger.info(CommonConstants.LOGGER_PREFIX,`PrefUtilInitStartupTask的回调，dependence:${dependence},result:${result}`)
  }
}