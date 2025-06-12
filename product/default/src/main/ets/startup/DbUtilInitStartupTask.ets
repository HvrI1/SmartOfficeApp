import { StartupTask, common } from '@kit.AbilityKit';
import { CommonConstants, DBUtil, KvUtil } from 'base';
import Logger from 'base/src/main/ets/util/Logger';

@Sendable
export default class DbUtilInitStartupTask extends StartupTask {


  constructor() {
    super();
  }

  async init(context: common.AbilityStageContext) {
    const kvUtil:KvUtil = KvUtil.getInstance() as KvUtil;
    const dbUtil:DBUtil = DBUtil.getInstance() as DBUtil;
    await kvUtil?.initKv(context);
    await dbUtil?.initDB(context);
    Logger.info(CommonConstants.LOGGER_PREFIX,`数据库kvUtil、数据库dbUtil启动成功`)
  }

  onDependencyCompleted(dependence: string, result: Object): void {
    Logger.info(CommonConstants.LOGGER_PREFIX,`DbUtilInitStartupTask的回调，dependence:${dependence},result:${result}`)
  }
}