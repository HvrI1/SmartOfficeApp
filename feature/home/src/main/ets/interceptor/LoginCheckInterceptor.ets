import { HMInterceptor, HMInterceptorAction, HMInterceptorInfo, HMRouterMgr, IHMInterceptor } from "@hadss/hmrouter";
import { CommonConstants } from "base";


@HMInterceptor({ interceptorName: 'LoginCheckInterceptor' })
export class LoginCheckInterceptor implements IHMInterceptor {
    handle(info: HMInterceptorInfo): HMInterceptorAction {
    if(!AppStorage.get(CommonConstants.APP_STORAGE_TOKEN)){
      info.context.getPromptAction().showToast({ message: '用户信息失效,请先登录' })
      HMRouterMgr.replace({
        pageUrl: 'LoginComp',
        param: info.targetName,
        skipAllInterceptor: true
      })
      return HMInterceptorAction.DO_REJECT;
    }else {
      return HMInterceptorAction.DO_NEXT
    }
  }


}





