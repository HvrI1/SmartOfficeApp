import { StartupConfig, StartupConfigEntry, StartupListener } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from 'base/src/main/ets/util/Logger';
import { CommonConstants } from 'base';

export default class MyStartupConfigEntry extends StartupConfigEntry {
  onConfig() {
    let onCompletedCallback = (error: BusinessError<void>) => {
      if (error) {
        Logger.error(CommonConstants.LOGGER_PREFIX, `MyStartupConfigEntry异常${error.code},${error.message}`)
      } else {
        Logger.info(CommonConstants.LOGGER_PREFIX, `MyStartupConfigEntry启动成功`);
      }
    };
    let startupListener: StartupListener = {
      'onCompleted': onCompletedCallback
    };
    let config: StartupConfig = {
      'timeoutMs': 10000,
      'startupListener': startupListener
    };
    return config;
  }
}