import { HMInterceptor, HMInterceptorAction, HMInterceptorInfo, HMRouterMgr, IHMInterceptor } from "@hadss/hmrouter";
import { CommonConstants, permissionManager } from "base";
import { Permissions } from "@kit.AbilityKit";
import { promptAction } from "@kit.ArkUI";

@HMInterceptor({interceptorName:"CheckPermissionInterceptor"})
export class CheckPermissionInterceptor implements IHMInterceptor{
  handle(info: HMInterceptorInfo): HMInterceptorAction {
    const  permissions:Permissions[] = [
      "ohos.permission.LOCATION",
      "ohos.permission.APPROXIMATELY_LOCATION"
    ]

    this.checkPermission(permissions)

    return HMInterceptorAction.DO_NEXT
  }

  //检查权限
  async  checkPermission(permissions:Permissions[]){
    try {
      //检查权限，不存在就提供弹窗
      if(!permissionManager.checkPermissions(permissions)){
        //弹窗初次授权，如果取消：throw Error就会被catch捕获
        await permissionManager.requestPermissions(permissions)
      }
    }catch{
      //捕获异常，捕获的是上面的取消操作
      //弹窗提示
      const res = await promptAction.showDialog({
        title:"权限提示",
        message:"考勤打卡需要获取定位权限才可使用，请前往系统设置开启定位权限！",
        alignment:DialogAlignment.Center,
        buttons:[
          {text:"取消",color:$r("app.color.button_primary_disabled")},
          {text:"前往设置",color:$r("app.color.button_primary")},
        ]
      })
      if(res.index === 1){
        permissionManager.openPermissionSettingPage()
      }else {
        //用户选择了取消，强制返回至主页，不让打卡。
        HMRouterMgr.pop({navigationId:CommonConstants.NAVIGATION_ID_PHONE,pageUrl:"IndexComp",skipAllInterceptor:true})
      }
    }
  }

}