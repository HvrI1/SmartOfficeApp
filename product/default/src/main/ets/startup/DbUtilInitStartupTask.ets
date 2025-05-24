import { StartupTask, common } from '@kit.AbilityKit';
import { CommonConstants, DBUtil, KvUtil } from 'basic';
import Logger from 'basic/src/main/ets/util/Logger';

@Sendable
export default class DbUtilInitStartupTask extends StartupTask {


  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    const kvUtil:KvUtil = KvUtil.getInstance() as KvUtil;
    const dbUtil:DBUtil = DBUtil.getInstance() as DBUtil;
    kvUtil?.initKv(context);
    dbUtil?.initDB(context);
  }

  onDependencyCompleted(dependence: string, result: Object): void {
    Logger.info(CommonConstants.LOGGER_PREFIX,`DbUtilInitStartupTask的回调，dependence:${dependence},result:${result}`)
  }
}